Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1DVPMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:12:53 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:4012 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753275Ab1DVPMv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:12:51 -0400
X-SpamScore: -40
X-BigFish: VPS-40(zz1803M9371O1447R542M1432N98dK4015Lzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
Date: Fri, 22 Apr 2011 09:12:42 -0600
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2] tty/serial: add support for Xilinx PS UART
Thread-Index: AcwAzToumuHZAoknS3+YKZ3srosTCQAI9qlwAAN7YbA=
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local> <4DB14626.8090002@petalogix.com> 
From: John Linn <John.Linn@xilinx.com>
To: <michal.simek@petalogix.com>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>,
        <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 22 Apr 2011 15:12:42.0862 (UTC) FILETIME=[BA4498E0:01CC00FF]
X-RCIS-Action: ALLOW
Message-ID: <a9a3298f-e87b-476d-8fca-47ce72b7b0bb@VA3EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: John Linn
> Sent: Friday, April 22, 2011 7:36 AM
> To: 'michal.simek@petalogix.com'
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; greg@kroah.com; grant.likely@secretlab.ca
> Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
> 
> > -----Original Message-----
> > From: Michal Simek [mailto:michal.simek@petalogix.com]
> > Sent: Friday, April 22, 2011 3:11 AM
> > To: John Linn
> > Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> > alan@lxorguk.ukuu.org.uk; greg@kroah.com; grant.likely@secretlab.ca
> > Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
> >
> > John Linn wrote:
> > > The Xilinx PS Uart is used on the new ARM based SoC. This
> > > UART is not compatible with others such that a seperate
> > > driver is required.
> > >
> > > Signed-off-by: John Linn <john.linn@xilinx.com>
> > > ---
> > >
> > > V2 Changes
> > >
> 
> Hi Michal,
> 
> I don't have a problem removing the empty lines, but is there some
> guideline on that
> which I'm ignoring and should know?

Those were pretty ugly, didn't realize they were all in there, no big
deal. I found a few more than you did :)

Thanks,
John

> 
> > AFAIK. Grant proposed to write it in different style. I think he
will
> > agree with me.
> >
> > #ifdef CONFIG_OF
> > static struct of_device_id xuartps_of_match[] __devinitdata = {
> > 	{ .compatible = "xlnx,xuartps", },
> > 	{}
> > };
> > MODULE_DEVICE_TABLE(of, xuartps_of_match);
> > #else
> > #define xuartps_of_match NULL
> > #endif
> >
> >
> > static struct platform_driver xuartps_platform_driver = {
> > 	.probe   = xuartps_probe,		/* Probe method */
> > 	.remove  = __exit_p(xuartps_remove),	/* Detach method */
> > 	.suspend = xuartps_suspend,		/* Suspend */
> > 	.resume  = xuartps_resume,		/* Resume after a
suspend */
> > 	.driver  = {
> > 		.owner = THIS_MODULE,
> > 		.name = XUARTPS_NAME,		/* Driver name */
> > 		.of_match_table = xuartps_of_match,
> > 	},
> > };
> >
> 
> I'll check it out, that does look familiar to me now that you say it.
> We've had this
> driver around for a while so it just needs to be updated to the newer
> style.
> 
> Easy enough.
> 
> Thanks for the review and input,
> John
> 
> > Regards,
> > Michal
> >
> >
> >
> > --
> > Michal Simek, Ing. (M.Eng)
> > PetaLogix - Linux Solutions for a Reconfigurable World
> > w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-
> > 30090663


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


