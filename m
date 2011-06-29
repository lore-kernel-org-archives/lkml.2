Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1F2Pbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:31:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53911 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1F2Pbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=4Pp1UYWFsBywRvLL1n=ggCZgAeA@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-3-git-send-email-ohad@wizery.com> <20110627210007.GC20865@ponder.secretlab.ca>
 <BANLkTi=4Pp1UYWFsBywRvLL1n=ggCZgAeA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Jun 2011 09:31:19 -0600
X-Google-Sender-Auth: TZmMGJwNBS69Tho537T3WeYfpw0
Message-ID: <BANLkTikGaYjjuXOb0ANM4+-j3nWFJ1BaCg@mail.gmail.com>
Subject: Re: [RFC 2/8] remoteproc: add omap implementation
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 9:04 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Jun 28, 2011 at 12:00 AM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>> Very little for me to comment on here.  However, something I just
>> noticed.  Why is it necessary to pass in THIS_MODULE to the
>> rproc_register function?  Having a reference to the pdev gives you the
>> pointer to the driver, which has the THIS_MODULE value in it.  That
>> should be sufficient.
>
> Nice one, thanks !
>
>> /me also isn't sure if incrementing the refcount on the module is the
>> best way to prevent the rproc from going away, but I haven't dug into
>> the details in the driver code to find out.  Drivers can get unbound
>> from devices without the driver being unloaded, so I imagine there is
>> an in-use count on the device itself that would prevent driver
>> unbinding.
>
> Yes, increasing the module refcount is necessary to prevent the user
> from removing the driver when the rproc is used.

That prevents removing the module which necessitates unbinding the
device.  However, I believe it is possible to unbind a driver
/without/ the module being unloaded.  My question (for which I don't
have an answer) is whether or not there is a way to increment a
refcount on users of the driver bound to the device..

g.
