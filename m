Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1IPTBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:01:25 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53246 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1IPTBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:01:24 -0400
Message-ID: <4E739CF7.2000202@linux.vnet.ibm.com>
Date: Fri, 16 Sep 2011 16:01:11 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: Christophe Henri RICARD <christophe-h.ricard@st.com>,
        Mohamed TABET <mohamed.tabet@st.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, "joe@perches.com" <joe@perches.com>,
        matt mooney <mfm@muteddisk.com>, Sean NEWTON <sean.newton@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: new stm i2c device driver
References: <0B9F1C5B86169C4EA9D042C251022E491060F260A1@SAFEX1MAIL3.st.com> <0B9F1C5B86169C4EA9D042C251022E4922E010E857@SAFEX1MAIL3.st.com> <8F888FAFF364DD4D9683684315E0207DD25D1F05CC@SAFEX1MAIL3.st.com> <4E569A0F.40601@linux.vnet.ibm.com> <0B9F1C5B86169C4EA9D042C251022E4922E010E8E0@SAFEX1MAIL3.st.com> <4E60EC61.4030004@linux.vnet.ibm.com>
In-Reply-To: <4E60EC61.4030004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
