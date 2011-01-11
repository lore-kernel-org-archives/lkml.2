Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1AKF0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:26:46 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:47977
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804Ab1AKF0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:26:40 -0500
Date: Tue, 11 Jan 2011 05:27:59 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Bastian Blank <bastian@waldi.eu.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 6/7] user namespaces: convert all capable checks in
 kernel/sys.c
Message-ID: <20110111052759.GA24970@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211406.GF22564@mail.hallyn.com>
 <20110110215937.GB21351@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110215937.GB21351@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Mon, Jan 10, 2011 at 09:14:07PM +0000, Serge E. Hallyn wrote:
> > -	if (pcred->uid  != cred->euid &&
> > -	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
> > +	if (pcred->user->user_ns != cred->user->user_ns &&
> > +	    pcred->uid  != cred->euid &&
> > +	    pcred->euid != cred->euid &&
> > +	    !ns_capable(pcred->user->user_ns, CAP_SYS_NICE)) {
> 
> I don't think this is correct. This would not error out if the both
> userns are the same. Because the same patern (check uid if same userns,
> otherwise only capability) shows up in several parts of the code, maybe
> this should be factored out.

Yeah, I'd really like to factor this out because it shows up everywhere
and I have to think about it every time I look at it.  But each time it
shows up, the uids being compared slightly change.  There must be some
clever way of doing it, hopefully it'll fall out soon.

Eric's ns_capable() has already simplified this quite a bit - which is
part of why I've sometimes not been thinking about it right, it's now
simpler than it used to be :)

thanks,
-serge
