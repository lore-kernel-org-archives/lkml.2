Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444Ab1KJPdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:33:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37887 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902Ab1KJPdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:33:05 -0500
MIME-Version: 1.0
In-Reply-To: <m3vcqsghkv.fsf@blackfin.pond.sub.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<4EBBD503.4020308@codemonkey.ws>
	<CAOJsxLH+Afuk-42aPwd9hcvhpmCD88t4-2N02M5oz8LBNZYETA@mail.gmail.com>
	<m3vcqsghkv.fsf@blackfin.pond.sub.org>
Date: Thu, 10 Nov 2011 15:33:04 +0000
Message-ID: <CAJSP0QWRBE6VLskVb0rYaVO3bEB6=8=F6GsNBjQAvn68X2aD2Q@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 2:47 PM, Markus Armbruster <armbru@redhat.com> wrote:
> Pekka Enberg <penberg@kernel.org> writes:
>
>> Hi Anthony,
>>
>> On Thu, Nov 10, 2011 at 3:43 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>>> It's not just the qcow2 implementation or even the block layer.  This pull
>>> requests adds a userspace TCP/IP stack to the kernel and yet netdev isn't on
>>> the CC and there are no Ack's from anyone from the networking stack.  I'm
>>> fairly sure if they knew what was happening here they would object.
>>
>> It's something we consider extremely important because it allows easy
>> non-root networking. But you're right, we definitely ought to ping the
>> networking folks before the next merge window.
>
> The problem is real.  The solution "duplicate in user space" sucks.  If
> you engaging with the kernel networking folks leads to one that doesn't
> suck, we should bathe you in free beer.

Look at disks, the problem is addressed by the udisks daemon on dbus.
Anything can try talking to it.  If you have permissions or can get
the user to authenticate then you can manipulate LVM volumes, mount
file systems, etc.  We could do something similar for tap networking.

The Ubuntu folks seem to want VDE instead to solve the same problem.
Create a VDE switch with a single tap device on startup.  Then let all
VMs talk to the VDE without privileges.

I don't think going through VDE is nice or performant, would be better
to have add virtual network functionality over dbus just like udisks
did for disks.

Stefan
