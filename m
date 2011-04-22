Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1DVRJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:09:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1DVRJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:09:17 -0400
Message-ID: <4DB1B62B.3000700@oracle.com>
Date: Fri, 22 Apr 2011 10:08:59 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com> <4DB1B37C.9070406@oracle.com> <4DB1B4F1.8070109@redhat.com>
In-Reply-To: <4DB1B4F1.8070109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB1B637.0015:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 10:03 AM, Eric Blake wrote:
>> cp can read whatever blocksize it chooses. If that block contains
>> zero, it would signal cp that maybe it should SEEK_DATA and skip
>> reading all those blocks. That's all. We are not trying to achieve
>> perfection. We are just trying to reduce cpu waste.
>>
>> If the fs supports SEEK_*, then great. If it does not, then it is no
>> worse than before.
> But providing just SEEK_DATA _is_ worse than before if you don't provide
> the correct SEEK_HOLE everywhere.  Because then your algorithm of trying
> lseek(SEEK_DATA) after every run of zeros in the hopes of an
> optimization is a wasted syscall, since it will just return your current
> offset every time, so you end up with more syscalls than if you had used
> the single lseek(SEEK_DATA) that returns the end of the file up front,
> and known that the remainder of the file has no holes to even try
> seeking past.

You are over-optimizing. strace any process on your box and you
will find numerous wasted syscalls.

