Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1A1KgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:36:21 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:38890 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752715Ab1A1KgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:36:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=coly.li;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Sy6nn5bzcIrQZocf59MJmMcAQCEYEXpUpB8qNJZPVG1rk+G0kQmgwREUx3y/hmdRNNyZA+BapWu1RAfOkfH2cJ5GvVe+1ts5tdtdysxhpoWWci6AJHT5MosxIsCZ1qGk;
Message-ID: <4D42A23B.4090302@coly.li>
Date: Fri, 28 Jan 2011 19:02:19 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andreas Schwab <schwab@redhat.com>
CC: David Laight <David.Laight@ACULAB.COM>,
        David Daney <ddaney@caviumnetworks.com>,
        Coly Li <bosong.ly@taobao.com>, Wang Cong <xiyou.wangcong@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
References: <4D41B213.4070606@caviumnetworks.com>	<AE90C24D6B3A694183C094C60CF0A2F6D8AC2D__37237.0892241181$1296205746$gmane$org@saturn3.aculab.com> <m31v3xxrlz.fsf@redhat.com>
In-Reply-To: <m31v3xxrlz.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 114.251.86.0 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年01月28日 18:14, Andreas Schwab Wrote:
> "David Laight"<David.Laight@ACULAB.COM>  writes:
>
>> Also, as (I think) in some of the generated code quoted,
>> use of __builtin_expect() with a boolean expression can
>> force some versions of gcc to generate the integer
>> value of the expression
>
> That's more likely a side effect of the definition of likely/unlikely:
> they expand to !!(x).
>

It seems whether or not using unlikely() inside arch implemented BUG_ON() is arch dependent. Maybe a reasonable method 
to use BUG_ON() is,
1) do not explicitly use unlikely() when using macro BUG_ON().
2) whether or not using unlikely() inside BUG_ON(), it depends on the implementation of BUG_ON(), including arch 
implementation.

So from current feed back, doing "unlikely() optimization" here doesn't make anything better.

Thanks for all of your feed back :-)

-- 
Coly Li
