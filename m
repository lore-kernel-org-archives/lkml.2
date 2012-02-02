Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab2BBX4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:56:54 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31631 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755407Ab2BBX4v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:56:51 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371I542M1432N98dKzz1202hzz8275bhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 3/6] drivers: hv: Cleanup the kvp related state in
 hyperv.h
Thread-Topic: [PATCH 3/6] drivers: hv: Cleanup the kvp related state in
 hyperv.h
Thread-Index: AQHM3U66rioNHVAWIE+lUxrVLjUsYJYq0IsA//97vdA=
Date: Thu, 2 Feb 2012 23:41:29 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B70927D@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1327708522-26914-1-git-send-email-kys@microsoft.com>
 <1327708562-26964-1-git-send-email-kys@microsoft.com>
 <1327708562-26964-3-git-send-email-kys@microsoft.com>
 <20120202232936.GA9614@kroah.com>
In-Reply-To: <20120202232936.GA9614@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, February 02, 2012 6:30 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> zbr@ioremap.net; Haiyang Zhang
> Subject: Re: [PATCH 3/6] drivers: hv: Cleanup the kvp related state in hyperv.h
> 
> On Fri, Jan 27, 2012 at 03:55:59PM -0800, K. Y. Srinivasan wrote:
> > Now cleanup the hyperv.h with regards to KVP definitions.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> >  include/linux/hyperv.h |   32 +++++++++++++++++++-------------
> >  1 files changed, 19 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > index 7332b3f..802ece8 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -137,7 +137,6 @@ struct hv_ku_msg {
> >
> >
> >
> > -#ifdef __KERNEL__
> >
> >  /*
> >   * Registry value types.
> > @@ -162,29 +161,36 @@ enum hv_kvp_exchg_pool {
> >  	KVP_POOL_COUNT /* Number of pools, must be last. */
> >  };
> >
> > +#ifndef __packed
> > +#define __packed __attribute__((packed))
> > +#endif
> 
> Why do this?
> 
> If you are so worried about this in userspace, then just change the
> values below to __attribute__((packed)), like all of the other public .h
> files do.

Greg,

When I ran the checkpatch script against these patches I got a warning that the
preferred directive was to use "__packed".  So, for the header file that will be
consumed in the kernel, I chose to go with the __packed. For inclusion of this
header file in the user space daemon, I put in this definition here. So rather
than having numerous warnings, I now have a single warning. If you prefer,
I can move this definition to the daemon code where it is really needed.

Regards,

K. Y 


