Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2DCH7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:59:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62534 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2DCH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:59:23 -0400
Message-ID: <4F7AADD7.5070802@suse.cz>
Date: Tue, 03 Apr 2012 09:59:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120331 Thunderbird/13.0a2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 25/69] TTY: con3215, remove tasklet for tty_wakeup
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz> <1333367693-3244-26-git-send-email-jslaby@suse.cz> <20120403054241.GA2700@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20120403054241.GA2700@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 07:42 AM, Heiko Carstens wrote:
> On Mon, Apr 02, 2012 at 01:54:09PM +0200, Jiri Slaby wrote:
>> tty_wakeup is safe to be called from all contexts. No need to schedule
>> a tasklet for that. Let us call it directly like in other drivers.
>>
>> And delete the tasklet completely.
> 
> Your patch actually reverts Martin's recent commit 656d912537
> "[S390] 3215 deadlock with tty_wakeup".
> I'm quite sure the reason for the deadlock still exists.
> Unfortunately the commit doesn't contain the call chain that
> led to fix.

Ok, I would really appreciate the trace.

If this is really an issue, we should provide a helper in the TTY layer
like tty_schedule_wakeup.

thanks,
-- 
js
suse labs


