Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1HVVWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:22:42 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:59135 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HVVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:22:40 -0400
Message-ID: <4E52C890.1060600@oracle.com>
Date: Mon, 22 Aug 2011 14:22:24 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com> <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com> <4E527C7F.9040807@oracle.com> <4E52984F.8050702@gmail.com>
In-Reply-To: <4E52984F.8050702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A02020B.4E52C89C.00CB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 10:56 AM, Marco Stornelli wrote:
> Il 22/08/2011 17:57, Sunil Mushran ha scritto:
>>
>> The following test was used to test the early implementations.
>> http://oss.oracle.com/~smushran/seek_data/
>>
>
> Thank you very much!! I found another point. Your test fails with my 
> implementation because here 
> (http://www.austingroupbugs.net/view.php?id=415) says: "If whence is 
> SEEK_DATA, the file offset shall be set to the smallest location of a 
> byte not within a hole and not less than offset. It shall be an error 
> if no such byte exists." So in this case I return ENXIO but the test 
> expects another value. I have to say that there is a bit of confusion 
> about the real behavior of this new feature :)
>

That's test 5.10, 5.12, 5.14. And it expects -ENXIO.

Which test is failing for you?
