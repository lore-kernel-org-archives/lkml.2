Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1FGEhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 00:37:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61550 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab1FGEg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=f1qDpHYOEigST91c7F1APo2X5eR5Dxix+rbaTlGrXJFLB8OqyXR/x/FP8C8VunhcBj
         6/aZQdnZWhMYwGsylj4fGPmijVLp8w8C5ORtSzJthIVbgjJYST38LITbJXVlXS1tuZq7
         PJ0UvmrO3sP3xGTH1qBS3AsXhBtkwg35N9FGY=
MIME-Version: 1.0
In-Reply-To: <4DEDA9C9.6000109@dsn.okisemi.com>
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
 <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com> <4DED0510.1030600@gmail.com>
 <BANLkTi=s2pnANPS5ZhjM9ZW8Bctk2v3DLw@mail.gmail.com> <4DEDA9C9.6000109@dsn.okisemi.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 7 Jun 2011 00:36:38 -0400
Message-ID: <BANLkTik0rS18wCbzkDqarvmwrEY5vLGp0A@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 00:32, Tomoya MORINAGA wrote:
> (2011/06/07 1:52), Grant Likely wrote:
>> Hahaha.  Oops, I can't remember the conversation I had 5 minutes after
>> getting off the phone.
>>
>> It should actually be Tomoya who can comment on the name change.
>
> As far as I know, this change doesn't occur any issue.
> However, I don't have perfect confidence about it.
> Could you give me any information about concern ?

KBUILD_MODNAME is automatically expanded from the file name.  so any
code using KBUILD_MODNAME cannot be renamed with 0 side effects.  the
question is whether the changed string makes a difference to the
driver.

so if the places where KBUILD_MODNAME is used doesn't actually care
about the contents of the string (and is purely for information
purposes only), then there shouldnt be a problem.  but if there is
implicit lookups/matching based on the string, then this is a problem.
-mike
