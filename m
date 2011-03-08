Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1CHTpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:45:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52072 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab1CHTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:45:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=txwdFrd7MJSQYEX5nTrB/cdaGRnEO/mhURHdBYSULM2SFqrEgawnNsmMQ74n9s7Obj
         nKEO+Bba+NxtAtRwLTkGeKaSb0/AEAjPCiPDba8347Dkbc7LQ7KuPpg+VmPIvvI/0Rx3
         of8KBGCR52VdO72+gbQYrqVvD6PYrPDqmrYWg=
MIME-Version: 1.0
In-Reply-To: <4D76833E.9010603@candelatech.com>
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
	<20110303135942.GA8969@tuxdriver.com>
	<AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>
	<20110307151201.GC2664@tuxdriver.com>
	<AANLkTi=7RSdKhzGazQFUnBZqzMQskOSHq=7E08uan2vu@mail.gmail.com>
	<4D767A4B.1060203@gmail.com>
	<4D76833E.9010603@candelatech.com>
Date: Tue, 8 Mar 2011 14:45:02 -0500
Message-ID: <AANLkTikPQt+njjFPB6sJ-mEcsx6f-R6TAOhEd8egkqhH@mail.gmail.com>
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 2:27 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 03/08/2011 10:49 AM, Justin P. Mattock wrote:
>>
>> On 03/07/2011 07:22 AM, Mohammed Shafi wrote:
>>>
>>> On Mon, Mar 7, 2011 at 8:42 PM, John W.
>>> Linville<linville@tuxdriver.com> wrote:
>>>>
>>>> On Sun, Mar 06, 2011 at 12:47:05AM -0800, Justin Mattock wrote:
>>>>
>>>>> full dmesg here:
>>>>> http://fpaste.org/5JQp/
>>>>> let me know if I need to supply any info(also I can try a bisect, but
>>>>> am in the middle of changing residencies, so it might not be right
>>>>> away)
>>>>
>>>> One of the Atheros guys suggested that you change a DMA timeout value.
>>>> Did you try that?
>>>
>>> John it looks like increasing the timeout also does not seems to help.
>>> A user reported this issue in ath9k developer list and he told that
>>> increasing the timeout did not fix this issue.
>>>
>>>>
>>>> John
>>>> --
>>>> John W. Linville Someday the world will need a hero, and you
>>>> linville@tuxdriver.com might be all we have. Be ready.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>
>> at barnes and noble, and I see this has fired off again. will see if I
>> can reproduce and bisect.
>
> This problem goes way back, and the driver has had lots of fixes in the
> last few months, so I'm not sure if bisecting is going to
> do you any good.
>
> Thanks,
> Ben

The warnings have been around since you added the check for the
problem, right?  I remember initially it was a WARN_ON, and I'd get a
steady flood of backtraces, and then it was switched to a
WARN_ON_ONCE.  I see these on every platform I have (x86_64, IXP425
and AR71xx) with AR9002 and AR9003.

-Brian
