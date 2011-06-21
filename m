Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1FUQPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:15:09 -0400
Received: from void.printf.net ([89.145.121.20]:55853 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1FUQPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:15:07 -0400
From: Chris Ball <cjb@laptop.org>
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: James Hogan <james@albanarts.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
References: <BANLkTikMc1WfJMJ2NeBr1E62dGjCj1Cd_w@mail.gmail.com>
	<20110621101725.GA670@rere.qmqm.pl>
Date: Tue, 21 Jun 2011 12:14:59 -0400
In-Reply-To: <20110621101725.GA670@rere.qmqm.pl> (=?utf-8?Q?=22Micha=C5=82?=
 =?utf-8?Q?_Miros=C5=82aw=22's?= message
	of "Tue, 21 Jun 2011 12:17:25 +0200")
Message-ID: <m239j3tb3w.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 21 2011, Michał Mirosław wrote:
> On Tue, Jun 21, 2011 at 10:55:34AM +0100, James Hogan wrote:
>> HAVE_EFFICIENT_UNALIGNED_ACCESS is a config option, therefore it needs
>> the CONFIG_ before it when used by the preprocessor.
>> 
>> Signed-off-by: James Hogan <james@albanarts.com>
>> ---
>>  drivers/misc/cb710/sgbuf2.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
>> index d019746..2a40d0e 100644
>> --- a/drivers/misc/cb710/sgbuf2.c
>> +++ b/drivers/misc/cb710/sgbuf2.c
>> @@ -47,7 +47,7 @@ static uint32_t sg_dwiter_read_buffer(struct
>> sg_mapping_iter *miter)
>> 
>>  static inline bool needs_unaligned_copy(const void *ptr)
>>  {
>> -#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>>  	return false;
>>  #else
>>  	return ((ptr - NULL) & 3) != 0;
>
> Acked-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>

Thanks, pushed to mmc-next for 3.0.

(James, your patch was corrupt due to a hard line break on the @@
line -- please fix that next time around.)

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
