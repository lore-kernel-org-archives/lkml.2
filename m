Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1IAXe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:34:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41942 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab1IAXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:34:25 -0400
Message-ID: <4E60167C.3090500@gmail.com>
Date: Fri, 02 Sep 2011 09:34:20 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] fix default __strnlen_user macro
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>		 <1314826019-22330-2-git-send-email-msalter@redhat.com>		 <4E5EC3FE.10307@gmail.com> <1314841084.2344.113.camel@deneb.redhat.com>	 <4E5EE5DB.3030101@gmail.com> <1314905032.1439.29.camel@deneb.redhat.com>
In-Reply-To: <1314905032.1439.29.camel@deneb.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/11 05:23, Mark Salter wrote:
> On Thu, 2011-09-01 at 11:54 +1000, Ryan Mallon wrote:
>> It should either be changed as I suggested, or the comment in uaccess.h
>> should be updated to reflect the actual behaviour of the function
>> (stating that it returns n + 1 in the case where n is reached). Either
>> way, its probably worth doing a quick check through the arch specific
>> versions to see what their behaviour really is. It looks like there are
>> potentially some subtle bugs at the callsites.
> I think commenting it in uaccess.h is the only sane way to go. Changing
> the semantics means changing all the arch-specific versions, most of
> which are asm code and changing most, if not all callsites. All of the
> arch-specific versions I looked at include the NULL count.
>

Agreed. Add a note to the comment that callers should check for a return 
value > n.

~Ryan


