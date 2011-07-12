Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab1GLDbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 23:31:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44280 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab1GLDbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 23:31:37 -0400
Message-ID: <4E1BBFFD.7030900@oracle.com>
Date: Tue, 12 Jul 2011 11:31:09 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen-blkfront: Don't send closing  notification to backend in
 blkfront_closing()
References: <4E16AE55.50500@oracle.com> <20110708160414.GA30120@dumpdata.com> <4E17A01F.8060505@oracle.com> <20110709131153.GA25916@dumpdata.com>
In-Reply-To: <20110709131153.GA25916@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E1BC014.006F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/11 21:11, Konrad Rzeszutek Wilk wrote:
>>>> 5. umount the partition/disk in guest, command hung. exactly at here, any
>>>>    IO request to the partition/disk will hang.
>>>
>>> I get that with the patch and without it:
>>>
>>> sh-4.1#
>>> sh-4.1# [  519.814048] block xvda: device/vbd/51712 was hot-unplugged, 1 stale handles
>>>
>>> sh-4.1# df -h
>>> Filesystem            Size  Used Avail Use% Mounted on
>>> none                  490M  120K  490M   1% /dev
>>> none                  490M  131M  359M  27% /lib/modules/3.0.0-rc6-00052-g3edce4b-dirty
>>> shm                    10M     0   10M   0% /dev/shm
>>> var_tmp                10M     0   10M   0% /var/tmp
>>> /dev/xvda              20G  173M   19G   1% /test
>>> sh-4.1# umount /test
>>>
>>> Any ideas?
>>
>> This caused by backend kthread stopped, any IO request to the real device will hang, that
>> is the patch intend to resolving.
> 
> I get this hang with the patch (and without). Is there a corresponding patch to the backend?
> (The backend is the same exact version as DomU - 3.0-rc6 + #stable/for-jens).

I tried xen and linux the latest code, 
# xm dmesg | grep "Xen version"
(XEN) Xen version 4.2-unstable (root@us.oracle.com) () Tue Jul 12 06:51:41 CST 2011

Dom0:
# uname -r
3.0.0-rc6-XYZxen

Guest
# uname -r
3.0.0-rc6-XYZxen

without the patch, after detach the device by xm block-detach timeout also umount hang in guest.
with my patch, xm block-detach timeout in Dom0, umount in guest worked!

Thanks,
Joe


