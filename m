Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1DVPzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:55:42 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:45247
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694Ab1DVPzl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:55:41 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1803M9371O542M1432N98dK4015Lzz1202hzz8275bhz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2] tty/serial: add support for Xilinx PS UART
Date: Fri, 22 Apr 2011 09:55:36 -0600
In-Reply-To: <BANLkTim2TyamL4Q+=b-So6phTF+Ng-cBUA@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2] tty/serial: add support for Xilinx PS UART
Thread-Index: AcwBBHgL5Js/ELcfTB2SylxcNzaJHQAAIM8g
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local> <BANLkTimhk-szP=gbZLpRrofi2EB2YbXrqg@mail.gmail.com> <BANLkTim2TyamL4Q+=b-So6phTF+Ng-cBUA@mail.gmail.com>
From: John Linn <John.Linn@xilinx.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>
X-OriginalArrivalTime: 22 Apr 2011 15:55:37.0868 (UTC) FILETIME=[B91754C0:01CC0105]
X-RCIS-Action: ALLOW
Message-ID: <fa307380-e187-4fc0-b97c-999d4864b92d@VA3EHSMHS028.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of
> Grant Likely
> Sent: Friday, April 22, 2011 9:46 AM
> To: John Linn
> Cc: linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; greg@kroah.com
> Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
> 
> On Fri, Apr 22, 2011 at 9:40 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
> > On Wed, Apr 20, 2011 at 1:03 PM, John Linn <john.linn@xilinx.com>
> wrote:
> >> The Xilinx PS Uart is used on the new ARM based SoC. This
> >> UART is not compatible with others such that a seperate
> >> driver is required.
> >>
> >> Signed-off-by: John Linn <john.linn@xilinx.com>
> >
> > Out of curiosity, who is the vendor of this uart IP block?  Is it new
> > hardware created by xilinx for zinq, or is it provided by a third
> > party.  If its from a third party it is within the realm of
> > possibility that a driver already exists for it.
> >
> > g.
> >> +/********************************Register
> Map********************************/
> >> +/** UART
> >> + *
> >> + * Register offsets for the UART.
> >> + *
> >> + */
> >> +#define XUARTPS_CR_OFFSET      0x00  /* Control Register [8:0] */
> >> +#define XUARTPS_MR_OFFSET      0x04  /* Mode Register [10:0] */
> >> +#define XUARTPS_IER_OFFSET     0x08  /* Interrupt Enable [10:0] */
> >> +#define XUARTPS_IDR_OFFSET     0x0C  /* Interrupt Disable [10:0] */
> >> +#define XUARTPS_IMR_OFFSET     0x10  /* Interrupt Mask [10:0] */
> >> +#define XUARTPS_ISR_OFFSET     0x14  /* Interrupt Status [10:0]*/
> >> +#define XUARTPS_BAUDGEN_OFFSET 0x18  /* Baud Rate Generator [15:0]
> */
> >> +#define XUARTPS_RXTOUT_OFFSET  0x1C  /* RX Timeout [7:0] */
> >> +#define XUARTPS_RXWM_OFFSET    0x20  /* RX FIFO Trigger Level [5:0]
> */
> >> +#define XUARTPS_MODEMCR_OFFSET 0x24  /* Modem Control [5:0] */
> >> +#define XUARTPS_MODEMSR_OFFSET 0x28  /* Modem Status [8:0] */
> >> +#define XUARTPS_SR_OFFSET      0x2C  /* Channel Status [11:0] */
> >> +#define XUARTPS_FIFO_OFFSET    0x30  /* FIFO [15:0] or [7:0] */
> >> +#define XUARTPS_BAUDDIV_OFFSET 0x34  /* Baud Rate Divider [7:0] */
> >> +#define XUARTPS_FLOWDEL_OFFSET 0x38  /* Flow Delay [15:0] */
> >> +#define XUARTPS_IRRX_PWIDTH_OFFSET 0x3C /* IR Minimum Received
> Pulse
> >> +                                               Width [15:0] */
> >> +#define XUARTPS_IRTX_PWIDTH_OFFSET 0x40 /* IR Transmitted pulse
> >> +                                               Width [7:0] */
> >> +#define XUARTPS_TXWM_OFFSET    0x44  /* TX FIFO Trigger Level [5:0]
> */
> 
> After a quick search:
> 
> from include/linux/atmel_serial.h
> #define ATMEL_US_CR             0x00                    /* Control
> Register */
> #define ATMEL_US_MR             0x04                    /* Mode
> Register */
> #define ATMEL_US_IER            0x08                    /* Interrupt
> Enable Register */
> #define ATMEL_US_IDR            0x0c                    /* Interrupt
> Disable Register */
> #define ATMEL_US_IMR            0x10                    /* Interrupt
> Mask Register */
> #define ATMEL_US_CSR            0x14                    /* Channel
> Status Register */
> #define ATMEL_US_RHR            0x18                    /* Receiver
> Holding Register */
> #define ATMEL_US_THR            0x1c                    /* Transmitter
> Holding Register */
> #define ATMEL_US_BRGR           0x20                    /* Baud Rate
> Generator Register */
> #define ATMEL_US_RTOR           0x24                    /* Receiver
> Time-out Register */
> #define ATMEL_US_TTGR           0x28                    /* Transmitter
> Timeguard Register */
> #define ATMEL_US_FIDI           0x40                    /* FI DI Ratio
> Register */
> #define ATMEL_US_NER            0x44                    /* Number of
> Errors Register */
> #define ATMEL_US_IF             0x4c                    /* IrDA Filter
> Register */
> 
> 
> Not exactly the same, but worth exploring

Yes that's the one I found closest also, but no cigar as not the same and 
different enough so I don't think it makes sense to try to reuse it.

The world doesn't need any more round wheels, but some must be more shiny than
others to some people.  Until hardware is open source I'm afraid that's the 
way it will be.

Thanks,
John

Please ignore the footer that follows as I'm working with corporate to see if
we get it removed and be a better open source citizen.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


