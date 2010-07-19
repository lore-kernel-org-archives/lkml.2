Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab0GSOo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 10:44:57 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:41060 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934486Ab0GSOo4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 10:44:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 864706.96417.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LuTfkR5qWkEkvn3glLbMjCGMj/OAN05f/L8NxBnI5cF+efbLEV2LQRqqznYQ6O58AW3Ye4zddk0IPj0UIClvkS8GdO/OYdZlTOol2uNJ6kUqE6Cj7N1NhgG3dh2CXcnELZDbagvkhdccAOc1KXj/YFxQK5RbhvyNHUtna5QYjAQ=;
Message-ID: <583384.61837.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: KKzXGHAVM1n4uKAt9rJfQffSDf2Mkae2zYF.u2OS9gUEYZ.
 2L3RZxfR8yZcDaglrrgDVJg4W8j7XV7fQhoJisQ5WyMMd__1tgPC68Bk_M6q
 ngTfvIm7cxhGv9sq0zinyhgXzRRGb3r0tQHaJ5eH3uIB8TCVgLdyvLTyeV4e
 booKPe6Mj6Wghcm7ORvfvfbOfiXuMqzMcUDa.XdVpqLo08LmjfP8B48emzIl
 MZurBNTLAD1Jq8UcGTcwTBpP6DgzZvlDYI7Qv5_xV5ye4lkSsbGaes3nuOtx
 OzDkF.xzjv0wCMaa7tA--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Mon, 19 Jul 2010 07:44:55 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv3 1/3] USB: gadget: mass/file storage: set serial number
To: Greg KH <greg@kroah.com>,
        =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
In-Reply-To: <op.vf3amtx27p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that case, should all the composite gadgets stop
> setting
> the iManufacturer, iProduct 

Certainly not.  Those are interface constants
that don't relate to device instances.  Every
instance of those gadgets should appear the same
(except for instance-specific state like serial#).


and iSerialNumber?

... that's an instance-specific thing which should
be managed properly.  The kernel can't do that, but
userspace can (ensuring the USB host always sees
unique serial IDs for devices).


>  My understanding
> is that the composite module parameters are only meant as a way
> to override what the module uses as default. 

They're meant as a way to specify values that may
not otherwise have been specified, or which need
to be overridden.  Standard module param behavior.


> 
> >> As a matter of fact, without this patch, the
> >> iSerialNumber module parameter won't work
> 
> > So submit a bugfix for that alone, making it
> > work everywhere...
> 
> iSerialNumber not working is not the main issue.  The
> main issue
> is that the serial number is not set by default
> which makes Windows sad (Windows uses serial
> number to distinguish different
> devices with the same vendor and product ID).  The
> serial number
> has to be set by default without the need for user to give

Bullcrap.

Do you understand the basic concept of "managed
identifiers"??  Like serial numbers. They need
 to be explicitly managed to be unique.

So for example two Linux-USB peripherals must never
re-use the same ID.  The way to do that is just not
commit the user error of forgetting to assign one
(or assigning a duplicate).

>            
> As you see, the iSerialNumber module parameter
> is ignored unless the
> gadget driver sets the iSerialNumber field of
> the device descriptor.
> 
So make that gadget code do that ... as I said,
fix such bugs, don't add more breakage.

