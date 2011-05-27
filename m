Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1E0S3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:29:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2118 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1E0S3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:29:53 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish <anish198519851985@gmail.com>
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306519311.1918.12.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 11:29:51 -0700
Message-ID: <1306520991.31864.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 23:31 +0530, anish wrote:
> From: anish kumar <anish198519851985@gmail.com>
[]
> v4 Suggested by Joe Perches(joe@perches.com) that names can
> have many forms.8 bit chars,commas,quotes,apostrphes,all sort
> of things.This is now taken care of.

NAK.  No it's not.

> Signed-off-by: anish kumar <anish198519851985@gmail.com>
[]
> +				if ($line =~ /^\s*$sign(.*)/i) {
> +					if ($1 !~ /^\s+([a-zA-Z\s\"\.\-\'\,]*.*)/i) {
> +						WARN("Space required after $sign\n" .
> +							$herecurr);

8 bit chars, digits?

> +					}
> +					if ($1 !~ /([\sa-zA-Z\"\.\-\'\,]*)\s<.*>/i) {
> +						WARN("Space required b/w Full Name & Mail-id:\n" .
> +							$herecurr);

For the 3rd time, please use this form:

        if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {

and if you really want email format validation,
use a separate function.


