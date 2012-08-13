Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2HMHXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:23:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38076 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2HMHXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:23:49 -0400
Message-ID: <5028AB81.8040801@suse.cz>
Date: Mon, 13 Aug 2012 09:23:45 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 12/41] mxser: allow overlapping vector
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz> <1344368886-24033-13-git-send-email-jslaby@suse.cz> <87r4rbsgow.fsf@rustcorp.com.au>
In-Reply-To: <87r4rbsgow.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 03:50 AM, Rusty Russell wrote:
> On Tue,  7 Aug 2012 21:47:37 +0200, Jiri Slaby <jslaby@suse.cz> wrote:
>> For many cards, this saves some IO space because interrupt status port
>> has precedence over the rest of ports on the card. Hence it can be
>> mapped to a hole in I/O ports.
>>
>> Here we add a kernel parameter which allows that if a user wants to.
>> But they need to explicitly enable it by a module parameter.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> ---
>>  drivers/tty/mxser.c |   35 +++++++++++++++++++++++++++++++----
>>  1 file changed, 31 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
>> index c162ee9..e64fe40 100644
>> --- a/drivers/tty/mxser.c
>> +++ b/drivers/tty/mxser.c
>> @@ -2337,11 +2337,36 @@ static struct tty_port_operations mxser_port_ops = {
>>   * The MOXA Smartio/Industio serial driver boot-time initialization code!
>>   */
>>  
>> +static bool allow_overlapping_vector;
>> +module_param(allow_overlapping_vector, bool, 444);
> 
> You mean 0444, right?

Of course I did. I wonder why patch posters like numbers instead of
names. I will change this to S_IRUGO.

thanks,
-- 
js
suse labs
