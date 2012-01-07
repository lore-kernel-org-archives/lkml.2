Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2AGUzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 15:55:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51105 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AGUzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 15:55:39 -0500
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <20120105193436.GC25386@ubuntu-macmini>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
	<1325617358-8286-2-git-send-email-seth.forshee@canonical.com>
	<CAPbh3ruqMQ8UFSehm7vX5i8YWzRFwF5=TX_f4n4dVkvmQa9Njw@mail.gmail.com>
	<20120105193436.GC25386@ubuntu-macmini>
Date: Sat, 7 Jan 2012 15:55:35 -0500
X-Google-Sender-Auth: oEHkuDXQvlsir0FvRzkjo5l4_EY
Message-ID: <CAPbh3rv86E9zqUbF4vrA2G=FaXyNHqD7+NZXRkzrzYAsHL8a_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ACPI: EC: Add ec_get_handle()
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg@redhat.com>,
        linux-acpi@vger.kernel.org, Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 2:34 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Thu, Jan 05, 2012 at 01:27:08PM -0500, Konrad Rzeszutek Wilk wrote:
>> 8
>> On Jan 3, 2012 2:05 PM, "Seth Forshee" <seth.forshee@canonical.com> wrote:
>> >
>> > toshiba_acpi needs to execute an AML method within the EC namespace
>> > to make hotkeys work on some platforms. Provide an interface to
>> > allow it to easily get a handle to the EC namespace for this purpose.
>> >
>> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> > ---
>> >  drivers/acpi/ec.c    |   10 ++++++++++
>> >  include/linux/acpi.h |    1 +
>> >  2 files changed, 11 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
>> > index b19a18d..e37615f 100644
>> > --- a/drivers/acpi/ec.c
>> > +++ b/drivers/acpi/ec.c
>> > @@ -445,6 +445,16 @@ int ec_transaction(u8 command,
>> >
>> >  EXPORT_SYMBOL(ec_transaction);
>> >
>> > +/* Get the handle to the EC device */
>> > +acpi_handle ec_get_handle(void)
>> > +{
>> > +       if (!first_ec)
>> > +               return NULL;
>> > +       return first_ec->handle;
>> > +}
>> > +
>> > +EXPORT_SYMBOL(ec_get_handle);
>>
>> shouldn't this be _GPL?
>
> I don't know. All the other ec_* interfaces are EXPORT_SYMBOL, so I did
> likewise. I'm happy to change it if _GPL is what ought to be used here.

My understanding (and this is from reading Greg KH's patches) is that
any new interface should use _GPL variant unless there is an absolute
need for it. Say, a binary driver that uses this function and there is
no other way around it.

>
