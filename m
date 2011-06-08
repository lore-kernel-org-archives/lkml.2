Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1FHTE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:04:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62555 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1FHTE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n9EoFSjWgniCeOMTZ/ju8xhXAY08M/zigV0k68ZIKxyZ+78j/EWEN3sI860ERpuInJ
         1jbqEA96gp2D39h0ciB+rAWSwqygdGn2Rs80c9mOnc7LZ9EKExZ649ZEy8QHQtSw7V8g
         lDmP72qcBe5GKFMKKeRjnpGqbTF5LxAVg2pCc=
MIME-Version: 1.0
In-Reply-To: <43F901BD926A4E43B106BF17856F0755018E536956@orsmsx508.amr.corp.intel.com>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
	<1307485593-27196-4-git-send-email-andi@firstfloor.org>
	<43F901BD926A4E43B106BF17856F0755018E536956@orsmsx508.amr.corp.intel.com>
Date: Wed, 8 Jun 2011 12:04:56 -0700
X-Google-Sender-Auth: ZP_q-98S6eODZirG6s7z7a_iWcE
Message-ID: <BANLkTikB7uWHf+6fuqm+2YiR_atv1vVA5w@mail.gmail.com>
Subject: Re: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 15:56, Rose, Gregory V <gregory.v.rose@intel.com> wrote:
>> -----Original Message-----
>> From: Andi Kleen [mailto:andi@firstfloor.org]
>> Sent: Tuesday, June 07, 2011 3:27 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: Andi Kleen; Kirsher, Jeffrey T; Brandeburg, Jesse; Rose, Gregory V
>> Subject: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
>>
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> The header extern type of ixgbevf_mbx_ops disagreed with
>> the actual declaration. Fix this here.
>>
>> This is rather scary. I haven't tested it. Did this
>> ever work?
>>
>> Cc: jeffrey.t.kirsher@intel.com
>> Cc: jesse.brandeburg@intel.com
>> Cc: gregory.v.rose@intel.com
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  drivers/net/ixgbevf/ixgbevf.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/ixgbevf/ixgbevf.h b/drivers/net/ixgbevf/ixgbevf.h
>> index b703f60..a2bbbb3 100644
>> --- a/drivers/net/ixgbevf/ixgbevf.h
>> +++ b/drivers/net/ixgbevf/ixgbevf.h
>> @@ -279,7 +279,7 @@ enum ixgbevf_boards {
>>
>>  extern struct ixgbevf_info ixgbevf_82599_vf_info;
>>  extern struct ixgbevf_info ixgbevf_X540_vf_info;
>> -extern struct ixgbe_mac_operations ixgbevf_mbx_ops;
>> +extern struct ixgbe_mbx_operations ixgbevf_mbx_ops;
>>
>>  /* needed by ethtool.c */
>>  extern char ixgbevf_driver_name[];
>> --
>> 1.7.4.4
>
> [Greg Rose]
> Huh.
>
> Well, mbx ops is a table of 8 pointers and mac ops is a table of 11 pointers, so the copy would have over written 3 * pointer-size words of some other memory.  But the 8 ops copied would have been correct so to the extent that we called them they worked.
>
> Now that I look at it you missed a another spot where the copy is done that uses the ixgbe_mac_operations instead of the ixgbe_mbx_operations.
>
> I'll fix that up.
>
> Nice catch!
>
> - Greg
> --

I have an updated patch by Greg in my queue, which I will be
submitting through David Miller's networking tree.  Thanks Andi and
Greg!

-- 
Cheers,
Jeff
