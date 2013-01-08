Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3AHGkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:40:35 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39428 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3AHGkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:40:32 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 01:40:31 EST
Date: Tue, 8 Jan 2013 10:34:45 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
Message-ID: <20130108063445.GA4537@cachalot>
References: <50EB7C50.3070605@schaufler-ca.com>
 <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
 <20130108145922.58ab8ad4796076c9d14b6197@canb.auug.org.au>
 <50EB9C7E.7090304@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EB9C7E.7090304@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 20:11 -0800, Casey Schaufler wrote:
> On 1/7/2013 7:59 PM, Stephen Rothwell wrote:
> > You probably also want to think a bit harder about the order of the
> > patches - you should introduce new APIs before you use them and remove
> > calls to functions before you remove the functions.
> >
> The unfortunate reality is that I couldn't find a good way to stage the
> changes. It's a wonking big set of infrastructure change. I could introduce
> the security blob abstraction separately but that is a fraction of the
> change. If it would have gone through mail filters as a single patch I'd
> have sent it that way.
> 
> I can spend time on patch presentation, and will if necessary.

I guess it can be divided this way:

1) Introduce lsm_get_cred(), etc. which unconditionally return
->security, ->i_security, etc.

2) Move all LSMs, procfs, etc. to the new API, a patch per LSM/subsystem.

3) Change structures along with new API.


The pro of the division is that if you have a bug in the series (and you
surely have! ;)) it is MUCH more simple to locate this bug (bisect, etc.).
Also it is more descriptive as you divide LSM changes and the core security
subsystem itself targeted on multiple LSMs which divides LSM
implementations (which might be not very important for someone) and the core
architecture (which is important for everybody).

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
