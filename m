Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0DZMax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:30:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59790 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab0DZMaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K4HSiQoL5XobAXBRRG8CJoMg2K0C/+o46nydBsBbxucljrjZVJDtPFhKfEdlHFZ5ag
         P7z03J2wU/GS8UG7QYxwgZqdWH+Ix1I26B69mjGXODvrDgLbhVLJzBgH7bnQ/vwb3axc
         KnaJGElWZHIDRXddnJg9OcOH9Whn9DyK4Z4Wg=
MIME-Version: 1.0
In-Reply-To: <201004261406.50107.oneukum@suse.de>
References: <1272191830-23675-1-git-send-email-abogani@texware.it>
	 <201004261406.50107.oneukum@suse.de>
Date: Mon, 26 Apr 2010 14:30:50 +0200
X-Google-Sender-Auth: 3abba2643631480e
Message-ID: <h2i63a49ef41004260530x49db3ddczf43423aa49f3b9e1@mail.gmail.com>
Subject: Re: [PATCH] USB: sisusbvga: Remove the BKL from open
From: Alessio Igor Bogani <abogani@texware.it>
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Neukum,

2010/4/26 Oliver Neukum <oneukum@suse.de>:
> Am Sonntag, 25. April 2010 12:37:10 schrieb Alessio Igor Bogani:
>> BKL is not needed here because necessary locking is already provided
>> by mutex sisusb->lock.
>
> Have you checked the fb layer doesn't need it?

The _open and _release functions are already serialized with mutex in
fb layer. So that mutex could be removed but in my opinion this job
should be done in a separate patch (like I have done some time ago for
nvidiafb driver). Now I would want suggest to remove BKL here only.

Ciao,
Alessio
