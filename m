Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0EJIGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 04:06:13 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56708 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298Ab0EJIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 04:06:08 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper API
Date: Mon, 10 May 2010 01:06:06 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; x86_64; ; )
Cc: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "hjanssen@microsoft.com" <hjanssen@microsoft.com>,
       "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
References: <4BE49778.6060800@zytor.com> <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org> <4BE6705C.3000206@zytor.com>
In-Reply-To: <4BE6705C.3000206@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005100106.07156.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 May 2010 01:20:44 am H. Peter Anvin wrote:
> On 05/09/2010 01:19 AM, tip-bot for H. Peter Anvin wrote:
> >  MODULE_AUTHOR("VMware, Inc.");
> >  MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
> > 
> > @@ -767,7 +767,7 @@ static int __init vmballoon_init(void)
> > 
> >  	 * Check if we are running on VMware's hypervisor and bail out
> >  	 * if we are not.
> >  	 */
> > 
> > -	if (!vmware_platform())
> > +	if (x86_hyper != &x86_hyper_vmware)
> > 
> >  		return -ENODEV;
> >  	
> >  	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
> 
> Note: I did not change the existing code, but this is an example of a
> very common bug: the appropriate error code for "hardware is not
> present" is ENXIO, not ENODEV.
>

Source please? I was not aware that there was a standard governing
returns code for module init methods.

-- 
Dmitry
