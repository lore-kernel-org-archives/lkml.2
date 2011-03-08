Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1CHEi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 23:38:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab1CHEi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 23:38:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cDK8Nvs5aUS13sUMxTtdsbFqMstoKBYnbaifCBAuIBo32Co22Lqyp8tUpYAnvxHSo3
         bUqhic2IJuDyjyghJx6Pnpgs7l0jEsv4ld8GyMty61a55FafviE4MXkEn6uWSftt/s6h
         PLQcFSYztm9Yehix37HEu5Ldl5NdmcAh/TAW0=
MIME-Version: 1.0
In-Reply-To: <20110308042601.GX22723@ZenIV.linux.org.uk>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
	<20110308042601.GX22723@ZenIV.linux.org.uk>
Date: Mon, 7 Mar 2011 22:38:25 -0600
Message-ID: <AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
From: Steve French <smfrench@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vinay Sawal <vinaysawal@gmail.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 10:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
>> Removed a compile time warning by initializing an uninitialized variable.
>
>> -     int rc;
>> +     int rc = -EFAULT;
>
> Why is that the right thing to do?  Other than "it made the compiler to
> STFU, therefore it is Good(tm)", please.

Hard to disagree with Al's logic, although changing the scope of rc to
within the for loop might also make both your compiler happy and more
sense.   In any case, I prefer real bug fixes.


-- 
Thanks,

Steve
