Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab0IFOPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:15:30 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60589 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0IFOPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZqkoJRz4fSbnwe/zxugUenRNcjdeiTDC6iEGX44xgUPbbxNu7thFIiB3JqVfG3PUVZ
         8XNhDJqgz8tHDr0ZxxJLTxZaV0bJ71aN4ehDRL07EYc9w8PZ4+xnOG7KbgdUXeMN1Weg
         RDVYeYmSqQW7Cx9LEE7/D/kM4seupgBaZg36w=
MIME-Version: 1.0
In-Reply-To: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
References: <AANLkTimCtN1hten5v+tdwG9yiKsFmSMPcQU-eLefDQkc@mail.gmail.com>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Mon, 6 Sep 2010 22:15:02 +0800
Message-ID: <AANLkTimXO7td7xxD1_MVACjbKomE0VBLLV7A1U0z00eR@mail.gmail.com>
Subject: Re: [PATCH] Function btree_get_extent: Incorrect if-else if statement
To: =?UTF-8?Q?Andr=C3=A9_Nogueira?= <andre.neo.net@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not correct.

2010/8/9 André Nogueira <andre.neo.net@gmail.com>:
> The btree_get_extent function (in file disk-io.c) calls the
> add_extent_mapping (in file extent_map.c). The add_extent_mapping
> function can return two values: 0 or -EEXIST.

It might return some other error values besides -EEXIST, the 'else if
(ret)' branch
is just against them.
Namely, we should do some thing special when EEXIST, and do another things
for all other errors.

Regards,
Zhu Yanhai
