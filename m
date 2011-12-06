Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab1LFBlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:41:00 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42115 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809Ab1LFBk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:40:58 -0500
Message-ID: <4EDD729E.2060402@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 18:40:46 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Curt Wohlgemuth <curtw@google.com>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Surbhi Palande <csurbhi@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
References: <CAO81RMa4uRsOsaK4G78EDvOenJpEdTp4y+rtkiDxaK9cASbMtA@mail.gmail.com> <alpine.LSU.2.00.1111201121120.1264@sister.anvils> <20111121165626.GD14568@thunk.org> <alpine.LSU.2.00.1111211331120.1879@sister.anvils> <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11120601-8974-0000-0000-000003F261C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 04:38 PM, Hugh Dickins wrote:
> On Mon, 21 Nov 2011, Hugh Dickins wrote:
>> On Mon, 21 Nov 2011, Ted Ts'o wrote:
>>> On Sun, Nov 20, 2011 at 12:59:10PM -0800, Hugh Dickins wrote:
>>>> On Tue, 8 Nov 2011, Curt Wohlgemuth wrote:
>>>> It appears that there's a bug with this patch:
>
> This has been outstanding for a month now, and we've heard no progress:
> please revert commit 02fac1297eb3 "ext4: fix partial page writes" for rc5.
>
> The problems appear on a 1k-blocksize filesystem under memory pressure:
> the hunk in ext4_da_write_end() causes oops, because it's playing with
> a page after generic_write_end() dropped our last reference to it; and
> backing out the hunk in ext4_da_write_begin() is then found to stop
> rare data corruption seen when kbuilding.
>
> Although I earlier reported that backing out the patch caused an fsx
> test to fail earlier, I've since found great variation in how soon it
> fails, and seen it fail just as quickly with 02fac1297eb3 still in.
> I also reported that I had to go back to 2.6.38 for fsx not to fail
> under memory pressure: you won't be surprised that that turned out to
> be because 2.6.38 defaults nomblk_io_submit but 2.6.39 mblk_io_submit.
>
> Thanks,
> Hugh
>


Hi there,

Have you tried Yongqiang's patch "[PATCH 1/2] ext4: let mpage_submit_io 
works well when blocksize < pagesize" ?  I have tried it and it does 
seem to help, but I am still running into some failures that I am trying 
to debug, but let please let us know if it helps the issues that you are 
seeing.  Thx!

Allison Henderson

