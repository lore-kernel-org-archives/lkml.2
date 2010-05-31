Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0EaHgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab0EaHga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:36:30 -0400
Message-ID: <4C0366E0.6040203@redhat.com>
Date: Mon, 31 May 2010 09:36:00 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring
 itself
References: <cover.1274903328.git.mst@redhat.com> <4BFF9366.5090103@redhat.com> <20100530112220.GA27611@redhat.com>
In-Reply-To: <20100530112220.GA27611@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/10 13:22, Michael S. Tsirkin wrote:
> On Fri, May 28, 2010 at 11:56:54AM +0200, Jes Sorensen wrote:
>> It looks pretty good to me, however one thing I have been thinking of
>> while reading through it:
>>
>> Rather than storing a pointer within the ring struct, pointing into a
>> position within the same struct. How about storing a byte offset instead
>> and using a cast to get to the pointer position? That would avoid the
>> pointer dereference, which is less effective cache wise and harder for
>> the CPU to predict.
>>
>> Not sure whether it really matters performance wise, just a thought.
> 
> I think this won't work: when PUBLUSH_USED_IDX is negotiated,
> the pointer is to within the ring.

Hmmm shame, it would be a nice optimization.

Maybe it's time to introduce the v2 ring format, rather than having
adding more kludges to the existing one?

Cheers,
Jes
