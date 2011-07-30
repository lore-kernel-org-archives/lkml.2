Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1G3Imo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 04:42:44 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:30690 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab1G3Imi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 04:42:38 -0400
Message-ID: <4E33C3F5.9000602@bfs.de>
Date: Sat, 30 Jul 2011 10:42:29 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
CC: Dan Carpenter <error27@gmail.com>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] w1: off by one in w1_f29_remove_slave()
References: <20110727095557.GL3824@shale.localdomain> <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
In-Reply-To: <9C2475AA-829E-4BB8-A3D2-2444803A33D3@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.07.2011 22:28, schrieb Jean-François Dagenais:
> Yup, confirmed, weird that I did not notice a crash, probably lucky shot in the environment I was using it.
> 
> On 2011-07-27, at 05:55, Dan Carpenter wrote:
> 
>> This reads past the end of the w1_f29_sysfs_bin_files[] array.  I
>> don't have this hardware, but I assume it crashes every time the
>> function is called.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Acked-by: Jean-François Dagenais <dagenaisj@sonatest.com>
>>
>> diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
>> index c377818..0da4e97 100644
>> --- a/drivers/w1/slaves/w1_ds2408.c
>> +++ b/drivers/w1/slaves/w1_ds2408.c
>> @@ -373,7 +373,7 @@ static int w1_f29_add_slave(struct w1_slave *sl)
>> static void w1_f29_remove_slave(struct w1_slave *sl)
>> {
>> 	int i;
>> -	for (i = NB_SYSFS_BIN_FILES; i <= 0; --i)
>> +	for (i = NB_SYSFS_BIN_FILES - 1; i <= 0; --i)
>> 		sysfs_remove_bin_file(&sl->dev.kobj,
>> 			&(w1_f29_sysfs_bin_files[i]));
>> }


Is there any reason to release the data "backwards" ?
The default way is to go upwards. that looks more readable.

for (i=0; i < NB_SYSFS_BIN_FILES ; i++)
  sysfs_remove_bin_file(&sl->dev.kobj, w1_f29_sysfs_bin_files+i);

re,
 wh
