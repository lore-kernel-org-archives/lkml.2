Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1BOMSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1BOMSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:18:10 -0500
Message-ID: <4D5A6EF4.3030905@redhat.com>
Date: Tue, 15 Feb 2011 13:17:56 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device	read-write
 for read-only mappings
References: <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com> <20110214140940.GM18742@htj.dyndns.org> <4D593AD8.7070901@redhat.com> <20110214154430.GR18742@htj.dyndns.org> <20110215101506.43d41ca8@notabene.brown> <20110215020351.GD5825@agk-dp.fab.redhat.com>
In-Reply-To: <20110215020351.GD5825@agk-dp.fab.redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 03:03 AM, Alasdair G Kergon wrote:
> On Tue, Feb 15, 2011 at 10:15:06AM +1100, Neil Brown wrote:
>> Sounds sensible ... though it is not all that easy to assemble an
>> array as 'read-only'....  it is possible though.
>  
> For dm, it is looking like this change will *require* an upgrade to
> userspace LVM tools: some people who just update their kernels without
> updating their LVM tools too may find booting their machine fails.  We
> are still evaluating exactly which parts of LVM and which classes of
> users are affected and how best to deal with this, but I know from
> experience that changes where a kernel update requires an associated
> userspace update are never well-received and we would normally try to
> give plenty of lead time by updating the userspace tools and starting to
> get them into the distributions before imposing the kernel change.

This little change is really problematic.

Not only lvm userspace has problems here, also cryptsetup is broken
for read-only mappings.

Of course this it can be easily fixed, but it take some time until
the new userspace is propagated to distros.

Seems it changed userspace API here. For example, this is no longer
working now:

        fd = open(device, O_RDWR | flags);
        if (fd == -1 && errno == EROFS) {
                *readonly = 1;
                fd = open(device, O_RDONLY | flags);
        }


Milan
