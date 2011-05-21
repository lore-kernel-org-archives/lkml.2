Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1EUQDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 12:03:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1817 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1EUQDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 12:03:08 -0400
Subject: Re: PATCH] patch to generate warning when signed-of line in patch
 in not proper
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: man.k1983@gmail.com, davej@redhat.com, rostedt@goodmis.org,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik2NVHNbG4mSZDWJ2Mt5i6AhGr+uw@mail.gmail.com>
References: <1305825809.2336.110.camel@anish-desktop>
	 <BANLkTik2NVHNbG4mSZDWJ2Mt5i6AhGr+uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 09:03:06 -0700
Message-ID: <1305993786.2068.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 20:14 +0530, anish singh wrote:
> Re-sending to get some comments on this.
> 
> On Thu, May 19, 2011 at 10:53 PM, anish <anish198519851985@gmail.com>
> wrote:
>         From: anish kumar <anish198519851985@gmail.com>
>         
>         This patch generates warning when there is no space between
>         the
>         patch submitter name and successive mail-id.

If you do this, why not do it for all signature types?

our $Valid_Signatures "(?:Signed-off-by:|Reviewed-by:|Acked-by:)"

>         Signed-off-by: anish kumar <anish198519851985@gmail.com>
>         ---
>          scripts/checkpatch.pl |   10 ++++++++--
>          1 files changed, 8 insertions(+), 2 deletions(-)
>         
>         diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>         index d867081..437c6d4 100755
>         --- a/scripts/checkpatch.pl
>         +++ b/scripts/checkpatch.pl
>         @@ -1373,10 +1373,16 @@ sub process {
>                                        WARN("Signed-off-by: is the
>         preferred form\n" .
>                                                $herecurr);
>                                }
>         -                       if ($line =~ /^\s*signed-off-by:\S/i)
>         {
>         -                               WARN("space required after
>         Signed-off-by:\n" .

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


