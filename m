Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1HVP6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:58:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56416 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1HVP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:58:01 -0400
Message-ID: <4E527C7F.9040807@oracle.com>
Date: Mon, 22 Aug 2011 08:57:51 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com> <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
In-Reply-To: <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E527C86.011C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 03:56 AM, Marco Stornelli wrote:
> 2011/8/22 Sunil Mushran<sunil.mushran@oracle.com>:
>> On 08/20/2011 09:32 AM, Marco Stornelli wrote:
>>> Thank. Yes the word "next" is not very clear. I re-read the proposal for
>>> the standard, actually it's seems to me that if we are in the last hole we
>>> should return the file size, if we are not in the last hole than it's ok the
>>> same offset - "....except that
>>> if offset falls beyond the last byte not within a hole, then the file
>>> offset may be set to the file size instead".
>> Any proposal that differentiates between holes is wrong. It should not
>> matter where the hole is.
>>
>> Think of it from the usage-pov.
>>
>> doff = 0;
>> while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
>>     hoff = lseek(SEEK_HOLE, doff);
>>     read_offset = doff;
>>     read_len = hoff -doff;
>>     process();
>>     doff = hoff;
>> }
>>
>> The goal is to make this as efficient as follows. Treating the last
>> hole differently adds more code for no benefit.
>>
> Mmmm.....It seems that Josef has to be clear in this point. However I
> looked for the seek hole test in xfs test suite, but I didn't find
> anything. Btrfs guys, how have you got tested the implementation? What
> do you think about this corner case? Al, what do you think about it?


The following test was used to test the early implementations.
http://oss.oracle.com/~smushran/seek_data/
