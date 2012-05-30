Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2E3G2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:28:41 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63130 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2E3G2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5BDF5.2040000@redhat.com>
References: <20120528102214.GB15202@dhcp-172-17-108-109.mtv.corp.google.com>
	<1338255542-22247-1-git-send-email-asias@redhat.com>
	<4FC4D2F2.2070309@gmail.com>
	<4FC5BDF5.2040000@redhat.com>
Date: Wed, 30 May 2012 15:28:37 +0900
X-Google-Sender-Auth: AYx1RB-9YO15MIsdMxN6fISvkA8
Message-ID: <CAOS58YMq1DiWgHGsjpABhaeYs9RjRgkHoifQQUKTKNi876bNgQ@mail.gmail.com>
Subject: Re: [PATCH V3] block: Mitigate lock unbalance caused by lock switching
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Tim Gardner <rtg.canonical@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 30, 2012 at 3:28 PM, Asias He <asias@redhat.com> wrote:
>> Isn't the 'if' clause superfluous ? You could just do the assignment,
>> e.g.,
>>
>> +       spin_lock_irq(lock);
>> +       q->queue_lock =&q->__queue_lock;
>> +       spin_unlock_irq(lock);
>
>
> Well, this saves a if clause but adds an unnecessary assignment if the lock
> is already internal lock.

It's not hot path. Dirtying the cacheline there doesn't mean anything.
I don't really care either way but making optimization argument is
pretty silly here.

-- 
tejun
