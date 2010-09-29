Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0I2A6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:58:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35246 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0I2A6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:58:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nUGwO1bBXn/ONrEafQL/bOmzDuRhhbDXNC8ERHE8mA2ywRd5x+ZWIaJljlYOv3ha3X
         qTxFugtwYMHIruQ6T1KrTLRU9M4T32WOdsNrxVoQ7mMfgVn7pVSxGDsAPGgwKagPbhGA
         DESRJbOM5zAAdcSbYNr7b3eorWMXln6rbVrUc=
MIME-Version: 1.0
In-Reply-To: <124506.1285721384@localhost>
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
	<AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
	<124506.1285721384@localhost>
Date: Wed, 29 Sep 2010 02:57:59 +0200
Message-ID: <AANLkTin+JRpTZsFO-neZ1Di=tskGK2Ne=xEKKpZrRB1C@mail.gmail.com>
Subject: Re: mmotm 2010-09-28-16-13 uploaded
From: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/29  <Valdis.Kletnieks@vt.edu>:
> On Wed, 29 Sep 2010 02:27:55 +0200, "N.P.S. N.P.S." said:
>> Hi,
>>
>> 2010/9/29  <akpm@linux-foundation.org>:
>> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
>>
>> I wonder why are these two functions in include/linux/fs.h
>> static inline void lock_flocks()
>> {
>> }
>>
>> static inline void unlock_flocks()
>> {
>> }
>
> Those were added as part of the kill-the-BKL project.  They used to be
> done as #defines to lock_kernel and unlock_kernel, but became full-fledged
> functions in this release.  Unfortunately, if you build with CONFIG_FILE_LOCKING=n
> you need to provide a dummy stub, which is what was intended here.
>
> Does the following (untested) fix the problem for you?

Yes, it does. Thanks!

>
> Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>
> --- linux-2.6.36-rc5-mmotm0928/include/linux/fs.h.dist  2010-09-28 20:46:29.276970365 -0400
> +++ linux-2.6.36-rc5-mmotm0928/include/linux/fs.h       2010-09-28 20:47:34.221924470 -0400
> @@ -1274,11 +1274,11 @@ static inline int lock_may_write(struct
>        return 1;
>  }
>
> -static inline void lock_flocks()
> +static inline void lock_flocks(void)
>  {
>  }
>
> -static inline void unlock_flocks()
> +static inline void unlock_flocks(void)
>  {
>  }
>
>
>



-- 
Slawa!
N.P.S.
