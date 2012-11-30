Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2K3FZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:25:20 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33290 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2K3FZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:25:18 -0500
MIME-Version: 1.0
In-Reply-To: <20121130021026.GB2056@kroah.com>
References: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
	<20121130021026.GB2056@kroah.com>
Date: Fri, 30 Nov 2012 14:25:17 +0900
Message-ID: <CAOTypNRjqE0aiP+s551wSciziOeqDZyuhQ+pe96fk8SVj2G64g@mail.gmail.com>
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in serqt_usb2.c
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:10 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 29, 2012 at 01:57:56PM +0900, YAMANE Toshiaki wrote:
>> Improved position to increment variable i,
>> And typo fixes.
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> ---
>>  drivers/staging/serqt_usb2/serqt_usb2.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
>> index 1b3e995..095d6f2 100644
>> --- a/drivers/staging/serqt_usb2/serqt_usb2.c
>> +++ b/drivers/staging/serqt_usb2/serqt_usb2.c
>> @@ -309,26 +309,26 @@ static void qt_status_change_check(struct tty_struct *tty,
>>                       case 0x00:
>>                               if (i > (RxCount - 4)) {
>>                                       dev_dbg(&port->dev,
>> -                                             "Illegal escape seuences in received data\n");
>> +                                             "Illegal escape sequence in received data\n");
>
> This is a different type of fix from:
>
>>                                       break;
>>                               }
>>
>> -                             ProcessLineStatus(qt_port, data[i + 3]);
>> -
>>                               i += 3;
>> +                             ProcessLineStatus(qt_port, data[i]);
>
> I think you just changed the logic in this function, didn't you?
>
>> +
>>                               flag = 1;
>>                               break;
>>
>>                       case 0x01:
>>                               if (i > (RxCount - 4)) {
>>                                       dev_dbg(&port->dev,
>> -                                             "Illegal escape seuences in received data\n");
>> +                                             "Illegal escape sequence in received data\n");
>>                                       break;
>>                               }
>>
>> -                             ProcessModemStatus(qt_port, data[i + 3]);
>> -
>>                               i += 3;
>> +                             ProcessModemStatus(qt_port, data[i]);
>
> Same here, what happens to i after this?
>
> Please break into two patches, and verify that you didn't break anything
> here.

Greg-san,

I am sorry for confusion.
I sent the patch twice since following patch was applied (gregkh/staging-next)

commit 9d36976fad3008fcc4209789566f7f3e7763f212
Modify qt_status_change_check() and delete qt_status_change().

-Incorporate comment of Mr.Joe Perches (sent Nov.17)
-I sent yesterday

Please discard the patches.

Thanks,


YAMANE Toshiaki
