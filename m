Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2CANvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:51:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47105 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CANvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:51:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.194.193 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301130311.GA7429@1984>
References: <1330593390-19233-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120301101809.GA6488@1984>
	<CAOD=uF6yqCETUG8jMCmjYDM+L1DsM91OiRveONJkNxMf=skTSg@mail.gmail.com>
	<20120301130311.GA7429@1984>
Date: Thu, 1 Mar 2012 19:21:45 +0530
Message-ID: <CAOD=uF6GizMhTWkriQCnV7T_2vzOSQ85sG1ruoEi_YtNSK+9kQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] netfilter: Fix copy_to_user too small size parametre.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Pablo for clarification.
I will resend the patch.


regards
santosh

On Thu, Mar 1, 2012 at 6:33 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 01, 2012 at 04:15:05PM +0530, santosh prasad nayak wrote:
>> Hi Pablo.
>>
>> copy_to_user( dest, source, length)
>>
>> Normally,  'length'  is equal to  'sizeof (source) '.
>>
>> In this case "length"   =   32
>>        "sizeof(source)"  =   29.
>>
>> Is it intentional ?
>
> ebtables expects 32 bytes names.
>
>> Won't it copy extra 3 bytes of kernel data to userspace ?
>
> You're right. We have to copy 29 bytes but we have to fill the
> remaining bytes with zeroes. I think something like:
>
> char name[EBT_FUNCTION_MAXNAMELEN] = {};
>
> /* user-space ebtables expects 32 bytes-long names, but xt_match uses
>  * 29 bytes for that. */
> sprintf(name, "%s", m->u.match->name);
> if (copy_to_user(hlp, name, EBT_FUNCTION_MAXNAMELEN))
> ...
>
> will resolve this issue.
>
> Would you resend a new patch?
