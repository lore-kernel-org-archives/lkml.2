Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1HVSCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:02:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46146 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1HVSCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:02:43 -0400
Message-ID: <4E52984F.8050702@gmail.com>
Date: Mon, 22 Aug 2011 19:56:31 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sunil Mushran <sunil.mushran@oracle.com>
CC: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>	<4E4F814B.5070202@gmail.com>	<4E4F865B.2010608@gmail.com>	<4E4FD48B.8030101@oracle.com>	<4E4FE1B1.7010601@gmail.com>	<4E51F24F.1050503@oracle.com> <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com> <4E527C7F.9040807@oracle.com>
In-Reply-To: <4E527C7F.9040807@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/08/2011 17:57, Sunil Mushran ha scritto:
>>> Any proposal that differentiates between holes is wrong. It should not
>>> matter where the hole is.
>>>
>>> Think of it from the usage-pov.
>>>
>>> doff = 0;
>>> while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
>>> hoff = lseek(SEEK_HOLE, doff);
>>> read_offset = doff;
>>> read_len = hoff -doff;
>>> process();
>>> doff = hoff;
>>> }
>>>
>>> The goal is to make this as efficient as follows. Treating the last
>>> hole differently adds more code for no benefit.
>>>
>> Mmmm.....It seems that Josef has to be clear in this point. However I
>> looked for the seek hole test in xfs test suite, but I didn't find
>> anything. Btrfs guys, how have you got tested the implementation? What
>> do you think about this corner case? Al, what do you think about it?
>
>
> The following test was used to test the early implementations.
> http://oss.oracle.com/~smushran/seek_data/
>

Thank you very much!! I found another point. Your test fails with my 
implementation because here 
(http://www.austingroupbugs.net/view.php?id=415) says: "If whence is 
SEEK_DATA, the file offset shall be set to the smallest location of a 
byte not within a hole and not less than offset. It shall be an error if 
no such byte exists." So in this case I return ENXIO but the test 
expects another value. I have to say that there is a bit of confusion 
about the real behavior of this new feature :)

Marco
