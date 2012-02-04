Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2BDChn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 21:37:43 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39015 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2BDChm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 21:37:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
References: <20120130140905.441199885@openvz.org>
	<20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	<20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	<20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	<20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	<CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	<1328311239.21255.24.camel@joe2Laptop>
Date: Fri, 03 Feb 2012 18:40:19 -0800
In-Reply-To: <1328311239.21255.24.camel@joe2Laptop> (Joe Perches's message of
	"Fri, 03 Feb 2012 15:20:39 -0800")
Message-ID: <m1k443nwx8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DMzygj9ZXPYRE//Y64Mf5Q7L/KvdA4yE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2b52aeb..89d24b3 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1924,6 +1924,12 @@ sub process {
>  			my $pre_ctx = "$1$2";
>  
>  			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
> +
> +			if ($line =~ /^\+\t{6,}/) {
> +				WARN("DEEP_INDENTATION",
> +				     "Too many leading tabs - consider code refactoring\n" . $herecurr);
> +			}

By any chance have you run this patch against itself? I find it comical
that there is a line 104 characters long suggesting people use shorter
lines.

>  			my $ctx_cnt = $realcnt - $#ctx - 1;
>  			my $ctx = join("\n", @ctx);
>  

Eric
