Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab1EWSJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:09:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1902 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab1EWSJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:09:28 -0400
Subject: Re: [patch v3] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, davej@redhat.com, rostedt@goodmis.org,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306167105.8687.11.camel@Joe-Laptop>
	 <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
	 <1306168598.8687.27.camel@Joe-Laptop>
	 <20110523093920.8f1e5cd0.rdunlap@xenotime.net>
	 <1306168975.8687.29.camel@Joe-Laptop>
	 <BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com>
	 <1306171117.8687.34.camel@Joe-Laptop>
	 <BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 11:09:26 -0700
Message-ID: <1306174166.8687.49.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 23:07 +0530, anish singh wrote:
> On Mon, May 23, 2011 at 10:48 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2011-05-23 at 22:36 +0530, anish singh wrote:
> > >  if ($1 !~ /[\sa-zA-Z\"]*\s<.*>/i) {
> > >  WARN("Space required b/w Full Name & Mail-id:\n" .
> > >       $herecurr);
> > > Quote has been taken care too now.
> > If you're going to try to validate email addresses,
> > please do it reasonably correctly or not at all.
> > At a minimum you need to add digits, single quote,
> > period, and comma.
> I think there is a confusion.Let me state it once again.
> This patch is used to check space between "signs" & name/ name &
> mail-id.

I'm not confused.

You are only checking names with this form (without quotes)
"First Last <fl@domain.tld>", now quoted as well.

Names can have many forms.

8 bit chars, commas, quotes, apostrophes, all sorts of things.

for instance:

$ git log v2.6.36.. | grep -P "by:.*" | \
	grep -vP "by:[\sa-zA-Z\"]*\s<.*>" | \
	sort | uniq -c | sort -rn | head -20
   3421     Signed-off-by: David S. Miller <davem@davemloft.net>
   3137     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
   2232     Signed-off-by: John W. Linville <linville@tuxdriver.com>
    386     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    292     Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
    257     Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    223     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    193     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
    167     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    166     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    159     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    126     Signed-off-by: Jean-François Moine <moinejf@free.fr>
    121     Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    107     Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
    106     Acked-by: David S. Miller <davem@davemloft.net>
    103     Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
     76     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
     69     Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
     66     Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
     63     Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

I still think what I suggested after your first patch
attempt is simple and appropriate.

our $Valid_Signatures "(?:Signed-off-by:|Reviewed-by:|Acked-by:)"
...
        if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {
                my $space_before = $1;
                my $sign_off = $2;
                my $space_after = $3;
                my $email = $4;
                if (defined $space_before && $space_before ne "") {
                        warning (no space before...)
                }
                if ($sign_off !~ /$Valid_Signature/) {
                        warning (signature case...)
                }
                if (!defined $space_after || $space_after ne " ") {
                        warning (need only one space after colon...)
                }
                if (!validate_email($4)) {
                        warning (bad email...)


