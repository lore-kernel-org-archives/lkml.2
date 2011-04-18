Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1DRWCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:02:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DRWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:02:34 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=wom5GMh1gUkA:10 a=n9MmX0RCC_8A:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=pGLkceISAAAA:8 a=J0KbT2UPHK0lOV7Bo-EA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 18 Apr 2011 17:02:32 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: crocket <crockabiscuit@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
Message-ID: <20110418220232.GA15967@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
 <20110417180722.GA21112@hallyn.com>
 <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
 <20110418082838.GA30088@hallyn.com>
 <BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting crocket (crockabiscuit@gmail.com):
> I have several questions.
> 
> 1) How do I set SECBIT_NO_SETUID_FIXUP?

prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP | SECBIT_NO_SETUID_FIXUP_LOCKED)

see capabilities(7) for details.

> 2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?

Yes, because it's what userspace expects.  If you prefer to run in
a full POSIX capabilities environment with unprivileged root, you
can have init set SECBIT_NO_SETUID_FIXUP and SECBIT_NOROOT and
tune userspace to do the right thing, but it's not trivial.

-serge
