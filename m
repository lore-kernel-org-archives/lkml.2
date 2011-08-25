Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1HYOO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:14:28 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:33868 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1HYOO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:14:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Topic: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
 mod_devicetable.h
Thread-Index: AQHMYtExhXIEHGcn2kWz/Ll10+yjQ5UtmyVA
Date: Thu, 25 Aug 2011 14:14:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B2EA6@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-3-git-send-email-kys@microsoft.com>
 <20110823224157.GA9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B236E@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824025913.GC30779@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B27B9@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110824201144.GA28667@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B29C8@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <6E21E5352C11B742B20C142EB499E048081B2AF2@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110825024014.GB6131@kroah.com>
In-Reply-To: <20110825024014.GB6131@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Wednesday, August 24, 2011 10:40 PM
> To: KY Srinivasan
> Cc: devel@linuxdriverproject.org; Haiyang Zhang; gregkh@suse.de; linux-
> kernel@vger.kernel.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 003/117] Staging: hv: Add struct hv_vmbus_device_id to
> mod_devicetable.h
> 
> On Thu, Aug 25, 2011 at 02:27:56AM +0000, KY Srinivasan wrote:
> > Since I don't have any (current) use for the driver_data pointer, I have gone
> ahead
> > and cleaned up the first 74 patches without adding the driver_data.
> > With the mushing of the patches   you had proposed this is about
> > a 60 patch series and addresses all the other comments you had in the first 74
> patches.
> > I hope I have gotten the "right" granularity now.   If it is ok with you, I could
> send these
> > out for your consideration.
> 
> Please do.
> 
> But if you do, do you mind if I add the driver_data pointer, so you can
> blame me later if no one uses it?  :)

Not at all! I will go ahead and send you these patches shortly.

> 
> > The only unresolved issue in the remaining patches (75 - 117) is the reference
> counting
> > issue we have been debating. As I noted in my earlier emails on this topic, the
> reference
> > counting has been there for a long time and I am reluctant get rid of that code
> without
> > additional testing/analysis. So I want to propose the following options:
> >
> > 1) Keep the existing code and I will skip the patches that cleaned up the
> reference counting
> >
> > 2) Take the cleanup that I have implemented
> >
> > In either case, I would further test and analyze this code to see if (a) the race
> condition that is being
> > addressed is valid and (b) if there is a different mechanism that could be used
> to deal with it. Given
> > the gaping holes in the current implementation, my personal preference would
> be to go with the
> > second option. Let me know what you want me to do here.
> 
> Ok, that sounds acceptable, but don't add the lock to the hv_driver, or
> is that needed right now?

Actually, last night I spent some considerable time understanding 
how this could be addressed differently and in a potentially simpler
way. I will go ahead and implement this scheme. Hopefully, I will be able
to send you these patches soon as well.

Regards,

K. Y


