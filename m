Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0JMMFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:05:44 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29790 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab0JMMFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:05:43 -0400
Message-ID: <000801cb6ace$f4e3d410$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <qi.wang@intel.com>, <margie.foster@intel.com>,
        <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>
References: <4C9C7C6F.1000003@dsn.okisemi.com> <4CA4541F.5040804@grandegger.com> <004a01cb6abe$c41a9cc0$66f8800a@maildom.okisemi.com> <4CB5931E.8030103@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Wed, 13 Oct 2010 21:05:33 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

On Wednesday, October 13, 2010 8:08 PM, Wolfgang Grandegger wrote:
> I disagree.

> I think it can be avoided easily.
> I disagree.
I will modify like you are saying.

> I don't understand! The Last Error Code (LEC) can have values from 0 to
> 7. A "switch" statement is therefore the right choice. Or have I missed
> something.
Yes, you are right.
I miss-understood.

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: <joel.clark@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; <kok.howg.ewe@intel.com>;
<yong.y.wang@intel.com>; <margie.foster@intel.com>; <qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
<linux-kernel@vger.kernel.org>; <netdev@vger.kernel.org>; <socketcan-core@lists.berlios.de>; "Samuel Ortiz"
<sameo@linux.intel.com>; "Barry Song" <21cnbao@gmail.com>; "Christian Pellegrin" <chripell@fsfe.org>; "Wolfram Sang"
<w.sang@pengutronix.de>; "David S. Miller" <davem@davemloft.net>
Sent: Wednesday, October 13, 2010 8:08 PM
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35


> On 10/13/2010 12:09 PM, Masayuki Ohtake wrote:
> > On Thursday, September 30, 2010 6:10 PM, Wolfgang Grandegger wrote:
> >
> >>
> >> + iowrite32(num, &(priv->regs)->if2_creq);
> >> + while (counter) {
> >>> + if2_creq = (ioread32(&(priv->regs)->if2_creq)) &
> >>> +      CAN_IF_CREQ_BUSY;
> >>> + if (!if2_creq)
> >>> + break;
> >>> + counter--;
> >>> + }
> >>> + if (!counter)
> >>> + dev_err(&priv->ndev->dev, "IF2 BUSY Flag is set forever.\n");
> >>> +}
> >>
> >> Duplicated code!
> >
> > No.
> > These are not the same.
>
> Of course they are not the same. The only difference is the register
> offset (of if1 or if2). A common function with a pointer to the if
> register as argument makes sense.
>
> > Though it is possible to integrate to one function by adding parameter,
> > I think, current two function method is more easily to read.
>
> I disagree.
>
> >>
> >>
> >>
> >>> + if (status & PCH_STUF_ERR)
> >>> + cf->data[2] |= CAN_ERR_PROT_STUFF;
> >>> +
> >>> + if (status & PCH_FORM_ERR)
> >>> + cf->data[2] |= CAN_ERR_PROT_FORM;
> >> +
> >> + if (status & PCH_ACK_ERR)
> >> + cf->data[2] |= CAN_ERR_PROT_LOC_ACK | CAN_ERR_PROT_LOC_ACK_DEL;
> >> +
> >> + if ((status & PCH_BIT1_ERR) || (status & PCH_BIT0_ERR))
> >> + cf->data[2] |= CAN_ERR_PROT_BIT;
> >> +
> >> + if (status & PCH_CRC_ERR)
> >> + cf->data[2] |= CAN_ERR_PROT_LOC_CRC_SEQ |
> >> + CAN_ERR_PROT_LOC_CRC_DEL;
> >> +
> >> + if (status & PCH_LEC_ALL)
> >> + iowrite32(status | PCH_LEC_ALL,
> >> +   &(priv->regs)->stat);
>
> Well, if status==7 (PCH_LEC_ALL), all of the above conditions are true
> as well... convinced now?
>
> >> A bit-wise test of the above values is wrong, I believe. Please use the
> >> switch statement instead.
> >
> > The above conditions are not only one time.
> > I think "switch" is not suitable for the above.
> > Thus, current "if" processing is better.
>
> I don't understand! The Last Error Code (LEC) can have values from 0 to
> 7. A "switch" statement is therefore the right choice. Or have I missed
> something.
>
> >>
> >>
> >> + u32 brp;
> >> +
> >> + pch_can_get_run_mode(priv, &curr_mode);
> >> + if (curr_mode == PCH_CAN_RUN)
> >> + pch_can_set_run_mode(priv, PCH_CAN_STOP);
> >>
> >> The device is stopped when this function is called. Please remove.
> >
> > No.
> > The above is necessary.
>
> Yes, because you started the device *too early* in pch_can_open() called
> by pch_open(). See my other related comments of my previous mail.
>
> > Because this is our HW specification.
> > Before setting bitrate, run-mode must be "STOP".
>
> I think it can be avoided easily.
>
> >>
> >>
> >> +static netdev_tx_t pch_xmit(struct sk_buff *skb, struct net_device *ndev)
> >> +{
> >> + canid_t id;
> >> + u32 id1 = 0;
> >> + u32 id2 = 0;
> >>
> >> Need these values to be preset?
> >
> > These values are not essential.
> > But these help a engineer to read this code.
>
> I disagree.
>
> >> + /* Enable CAN Interrupts */
> >> + pch_can_set_int_custom(priv);
> >> +
> >> + /* Restore Run Mode */
> >> + pch_can_set_run_mode(priv, PCH_CAN_RUN);
> >> +
> >> + return retval;
> >> +}
> >>
> >> Are the suspend and resume functions tested?
> >>
> > Yes, we tested before.
> >
> > =========================================
> >
> > Except the above, we are modifying for your indications.
> >
> > I will resubmit soon.
>
> Thanks,
>
> Wolfgang.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


