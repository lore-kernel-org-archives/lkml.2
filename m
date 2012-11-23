Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2KWRd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:33:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2KWRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:33:53 -0500
Message-ID: <50AFB373.8020507@oracle.com>
Date: Fri, 23 Nov 2012 11:33:39 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH v4 00/31] loop: Issue O_DIRECT aio using bio_vec
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com> <20121122194731.GA12057@infradead.org>
In-Reply-To: <20121122194731.GA12057@infradead.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 01:47 PM, Christoph Hellwig wrote:
> On Wed, Nov 21, 2012 at 04:40:40PM -0600, Dave Kleikamp wrote:
>> It introduces new file ops, read_iter() and write_iter(), that replace the
>> aio_read() and aio_write() operations. The iov_iter structure can now contain
>> either a user-space iovec or a kernel-space bio_vec. Since it would be
>> overly complicated to replace every instance of aio_read() and aio_write(),
>> the old operations are not removed, but file systems implementing the new
>> ones need not keep the old ones.
> 
> How many instance of the old ones are left?  I'd really prefer to make
> the full transition very quickly, even if not nessecarily in a single
> patchset.

The only file systems left are ceph, cifs, fuse and ntfs, but there are
the pipe driver and quite a few character devices that implement
aio_read and aio_write. It would be easy enough put a read/write_iter
wrapper around the non-block devices that return an error or even panic
if !iov_iter_has_iovec(iter), but I didn't like the way it looked.

(I think "git grep -e \\\.aio_read -e \\\.aio_write" find them all.)

If the consensus is to go that route, I'd be happy to work on a
follow-up patchset.

Shaggy
