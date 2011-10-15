Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1JOLp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 07:45:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1JOLp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 07:45:28 -0400
MIME-Version: 1.0
In-Reply-To: <20111014224549.GA22810@sig21.net>
References: <20111014192153.GA18439@sig21.net>
	<Pine.LNX.4.44L0.1110141613420.2036-100000@iolanthe.rowland.org>
	<20111014224549.GA22810@sig21.net>
Date: Sat, 15 Oct 2011 13:45:27 +0200
Message-ID: <CA+O4pCKbJCtF53jUBvQMX+zgPZ=YxCwGHyP-8JMx=++d5sCiCA@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 12:45 AM, Johannes Stezenbach <js@sig21.net> wrote:
> On Fri, Oct 14, 2011 at 04:19:34PM -0400, Alan Stern wrote:
>> On Fri, 14 Oct 2011, Johannes Stezenbach wrote:
>>
>> > I don't really want to help Markus with his proprietary, binary-only
>> > userspace driver crap, but I wonder why nobody seems to remember
>> > how the USB protocol works on the wire?
>>
>> I remember it perfectly well.
>
> My bad, I'm sorry for hitting the wrong tone.
>
> What I meant to say is Markus' statement that the device only
> works at a certain transfer size cannot be true since
> this size is not visible to the device via the USB bus.
>

The log files and demonstration video say something different. Plus
the same happens with MacOSX. And
Windows is using the same. So that means that something has been
overlooked so far.
The "off-by-one error" must be caused by something. In practice it
doesn't seem to be relevant as all
other USB stacks can handle this.

>> > Apparently the device can only handle fixed size packets
>> > of either 188 or 2*188 byte, thus it breaks with 12288 or 11776.
>>
>> No.  The device expects 512-byte packets because it uses a bulk
>> endpoint.
>>
>> > The endpoint's wMaxPacketSize might reflect this.
>>
>> For high-speed devices, a bulk endpoint's wMaxPacketSize must always be
>> 512.
>
> OK, after re-reading the USB spec I see you are right
> and I stand corrected.
>
>> > I guess a transfer size of e.g. 188*60=11280 would work.
>> > See the first mail of this thread.
>>
>> According to Markus, with this particular device nothing but 24064
>> works.  The discussion is a little difficult to follow because he
>> talked about two different devices without always being clear about
>> which was which.
>
> If you queue two URBs, one 12288 and 11776 bytes, the device
> does not see any difference to one URB with 24064.  It's just not
> in the USB wire protocol.  It would make a difference if the
> device violated the spec and sent 188 byte packets. However, the
> spec says a short packet terminates the transfer.  But I wonder
> if this is really the case?
>

I can send a sample device in around one month to Alan so he can have a look
at it with the bus analyzer. However I would be happy to see Alan's
proposal about the
16 MB limitations included since that one also solves the issue and even USB 3.0
would benefit from this as it seems.

BR,
Markus
