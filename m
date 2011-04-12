Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1DLBtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:49:47 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:42497 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1DLBtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BLylcAq9oOimgdu0DtyuNX7c9iyUPF9kgB+J3c7xXGm0hlu4fGsodyF3dILrZ/1s8L
         GzFyojNhGkUV1zpuQSzFXXbE/wy7lbbw1Aiqoi5rY01a+uml2a5oymwYGdmlsK17Wj/D
         Obk4q7DqEG98D1SouUyqRpm1T6Ol7TYOjh1pk=
Message-ID: <4DA3AFB3.4020802@gmail.com>
Date: Mon, 11 Apr 2011 18:49:39 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtSRkNdRG9jdW1lbnRhdGlvbjphY2NvdW50aW5nOmdldGRlbGE=?=
 =?UTF-8?B?eXMuYyBGaXg6IHdhcm5pbmc6IHZhcmlhYmxlIOKAmGnigJkgc2V0IGJ1dCBub3Q=?=
 =?UTF-8?B?IHVzZWQ=?=
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com> <20110411115654.9ff67799.rdunlap@xenotime.net>
In-Reply-To: <20110411115654.9ff67799.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 11:56 AM, Randy Dunlap wrote:
> On Tue,  5 Apr 2011 09:02:50 -0700 Justin P. Mattock wrote:
>
>> The below patch takes care of the warning, but keep in mind am unsure if this is a correct way
>> to resolve this issue.
>> Documentation/accounting/getdelays.c: In function ‘main’:
>> Documentation/accounting/getdelays.c:436:7: warning: variable ‘i’ set but not used [-Wunused-but-set-variable]
>>
>> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
>> Documentation/accounting/getdelays.c: In function ‘get_family_id’:
>> Documentation/accounting/getdelays.c:172:14: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
>
> Hi,
> Does -Wunused-but-set-variable require gcc 4.6.0?
>
>

not sure.. think its part of the whole "have gcc debug and clean things 
while it builds" feature with 4.6.0

>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   Documentation/accounting/getdelays.c |    3 ---
>>   1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
>> index e9c7778..16e16d5 100644
>> --- a/Documentation/accounting/getdelays.c
>> +++ b/Documentation/accounting/getdelays.c
>> @@ -433,8 +433,6 @@ int main(int argc, char *argv[])
>>   	}
>>
>>   	do {
>> -		int i;
>> -
>>   		rep_len = recv(nl_sd,&msg, sizeof(msg), 0);
>>   		PRINTF("received %d bytes\n", rep_len);
>>
>> @@ -459,7 +457,6 @@ int main(int argc, char *argv[])
>>
>>   		na = (struct nlattr *) GENLMSG_DATA(&msg);
>>   		len = 0;
>> -		i = 0;
>>   		while (len<  rep_len) {
>>   			len += NLA_ALIGN(na->nla_len);
>>   			switch (na->nla_type) {
>> --
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>

