Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1ISNib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:38:31 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:39020 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755759Ab1ISNi3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:38:29 -0400
From: Mohamed TABET <mohamed.tabet@st.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Christophe DELAUNAY <christophe.delaunay@st.com>
Cc: Christophe Henri RICARD <christophe-h.ricard@st.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, "joe@perches.com" <joe@perches.com>,
        matt mooney <mfm@muteddisk.com>, Sean NEWTON <sean.newton@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Date: Mon, 19 Sep 2011 15:37:47 +0200
Subject: RE: [PATCH 1/1] TPM: new stm i2c device driver
Thread-Topic: [PATCH 1/1] TPM: new stm i2c device driver
Thread-Index: Acx0owzGv3qFMohlQZGvUVYOihbuPwCLiLmg
Message-ID: <8F888FAFF364DD4D9683684315E0207DD26171E591@SAFEX1MAIL3.st.com>
References: <0B9F1C5B86169C4EA9D042C251022E491060F260A1@SAFEX1MAIL3.st.com>
 <0B9F1C5B86169C4EA9D042C251022E4922E010E857@SAFEX1MAIL3.st.com>
 <8F888FAFF364DD4D9683684315E0207DD25D1F05CC@SAFEX1MAIL3.st.com>
 <4E569A0F.40601@linux.vnet.ibm.com>
 <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com>
 <4E60EC61.4030004@linux.vnet.ibm.com> <4E739CF7.2000202@linux.vnet.ibm.com>
In-Reply-To: <4E739CF7.2000202@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Christophe Delaunay in the loop.

M.Tabet

-----Original Message-----
From: Rajiv Andrade [mailto:srajiv@linux.vnet.ibm.com] 
Sent: 16 September, 2011 21:01
To: Rajiv Andrade
Cc: Christophe Henri RICARD; Mohamed TABET; Marcel Selhorst; linux-kernel@vger.kernel.org; James Morris; joe@perches.com; matt mooney; Sean NEWTON; Jean-Luc BLANC
Subject: Re: [PATCH 1/1] TPM: new stm i2c device driver


On 02-09-2011 11:46, Rajiv Andrade wrote:
>>>>> +static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
>>>>> >>>> +                      wait_queue_head_t *queue)
> Sounds a copy & paste issue here, but *queue isn't being used here.
>>>>> >>>> +{
>>>>> >>>> +     unsigned long stop;
>>>>> >>>> +     u8 status;
>>>>> >>>> +
>>>>> >>>> +     FUNC_ENTER();
>>>>> >>>> +
>>>>> >>>> +     /* check current status */
>>>>> >>>> +     status = tpm_stm_i2c_status(chip);
>>>>> >>>> +     if (status == mask)
>>>>> >>>> +             return 0;
>>>>> >>>> +     if (status == TPM_STS_CANCEL)
>>>>> >>>> +             goto end;
>>>>> >>>> +     stop = jiffies + timeout;
>>>>> >>>> +     do {
>>>>> >>>> +             msleep(TPM_TIMEOUT);
>>>>> >>>> +             status = tpm_stm_i2c_status(chip);
>>>>> >>>> +             if ((status & mask) == mask)
>>>>> >>>> +                     return 0;
>>>>> >>>> +     } while (time_before(jiffies, stop));
>>>>> >>>> +end:
>>>>> >>>> +     return -ETIME;
>>>>> >>>> +}
>>>>> >>>> +
> This is very similar to what's in tpm_tis.c, given there's one more user for it now, it's a good time
> to move it to tpm.c and provide it tpm_stm_i2c_status or tpm_tis_status as a function pointer.
Just moved wait_for_stat to tpm.c so other drivers can use it. The changes were committed to:

github.com:srajiv/tpm.git

Rajiv
