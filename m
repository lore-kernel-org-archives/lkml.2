Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1CNUDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:03:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1CNUDy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Jvvp6OBwGn9YqLGvlPKqklsh/4c6EJ/MkR35thAk9LVDwroqtR8Yr7vH92+HL+9xjf
         y0DyWirXCi1RqOop08VA==
MIME-Version: 1.0
In-Reply-To: <4D7D9F92.5010604@kernel.org>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com> <4D7D9F92.5010604@kernel.org>
From: Mike Waychison <mikew@google.com>
Date: Mon, 14 Mar 2011 13:03:30 -0700
Message-ID: <AANLkTino-QB=2ctS4QFWQAr3gXTc5GfC5q5bQcFguVNs@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 9:54 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> On 03/11/2011 05:43 PM, Mike Waychison wrote:
>> This patch introduces the 'memconsole' driver.
>>
>> Our firmware gives us access to an in-memory log of the firmware's
>> output.   This gives us visibility in a data-center of headless machines
>> as to what the firmware is doing.
>>
>> The memory console is found by the driver by finding a header block in
>> the EBDA.  The buffer is then copied out, and is exported to userland in
>> the file /sys/firmware/log.
>>
>
> OK, I really don't like this.
>
> All it has is a 32-bit nonrandom signature, no DMI keying or anything
> else to protect it.  This really isn't sufficient.

Good point.  I'll add some DMI strings checks.  It *should* be
sufficient to just ensure that "Google, Inc." is the board vendor
string (though I'll need to run some tests to verify that this covers
the boards we care about).
