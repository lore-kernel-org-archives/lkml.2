Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1DRXPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:15:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1DRXPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=S9gzIyWbn5HGNF7k9cEiDfHPLdHytKU/wLB7XldFeXvT0WuTUhzvTq6WiagvBv74wF
         lIJhBNVkVbM7X1AZ8aBTYQHgbjmpRG2c9smKTvRM798muad2/1o4Li8Gi9o11yVsfSRx
         d13Q86TBFuWNtF4qKBuQ+xVC4S6GnpkH74xM8=
MIME-Version: 1.0
In-Reply-To: <20110418230254.GA22588@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com>
 <87tye1ckhr.fsf@linux.vnet.ibm.com> <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
 <20110418230254.GA22588@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 Apr 2011 01:14:57 +0200
Message-ID: <BANLkTik2eRURBtdWCrYF5g3i90PJTVe9Fw@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Dave Jones <davej@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 01:02, Dave Jones <davej@redhat.com> wrote:
> On Tue, Apr 19, 2011 at 12:57:27AM +0200, Kay Sievers wrote:
>
>  > > uuid:<value> is the option field  as per
>  > > Documentation/filesystem/proc.txt. There was an error in libmount
>  > > parsing which got fixed upstream recently
>  >
>  > Just a simple question about this approach in general? A filesystem
>  > UUID can be changed on disk at any time (tune2fs -U ...).
>  >
>  > Your code looks like you copy the bytes to the in-kernel superblock
>  > structure without noticing any later changes on disk? How is that
>  > supposed to work?
>
> I thought tune2fs on a mounted filesystem was always a
> "you get to keep both pieces if it breaks" situation.

No idea, it works fine that way since forever. :)

$ cat /proc/self/mountinfo | grep sda1
21 1 8:1 / / rw,relatime - ext4 /dev/sda1 rw, ...

$ blkid /dev/sda1
/dev/sda1: LABEL="root" UUID="0e4974cc-6a11-11e0-8d7b-002186a23ce5" TYPE="ext4"

$ tune2fs -U time /dev/sda1
tune2fs 1.41.14 (22-Dec-2010)

$ blkid /dev/sda1
/dev/sda1: LABEL="root" UUID="26be6e7c-6a11-11e0-ad62-002186a23ce5" TYPE="ext4"

I don't think that approach makes any sense without doing a call into
the filesystem, and such calls have no place in mountinfo.

Kay
