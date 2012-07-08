Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2GHI65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 04:58:57 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:43530 "HELO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751599Ab2GHI6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 04:58:55 -0400
Message-ID: <4FF94BC6.3000704@liveu.tv>
Date: Sun, 08 Jul 2012 11:58:46 +0300
From: Shachar Shemesh <shachar@liveu.tv>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] tty ldisc: Close/Reopen race prevention should
 check the proper flag
References: <4FEFF3DF.9000909@liveu.tv> <20120706212430.GA454@kroah.com>
In-Reply-To: <20120706212430.GA454@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------030506020805060906030604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030506020805060906030604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/07/2012 12:24 AM, Greg KH wrote:
> On Sun, Jul 01, 2012 at 09:53:19AM +0300, Shachar Shemesh wrote:
>> From: Shachar Shemesh <shachar@liveu.tv>
>>
>> Commit acfa747b introduced the TTY_HUPPING flag to distinguish
>> closed TTY from currently closing ones. The test in tty_set_ldisc
>> still remained pointing at the old flag. This causes pppd to
>> sometimes lapse into uninterruptible sleep when killed and
>> restarted.
>>
>> Signed-off-by: Shachar Shemesh <shachar@liveu.tv>
>> ---
>> Tested with 3.2.20 kernel.
>>
> All tabs are converted to spaces and make this patch impossible to apply
> :(
>
> Care to try again?
I'm sorry, I'm sending this as an attachment. I've verified that my 
mailer sends this as plain text, so it should be okay.

Shachar


--------------030506020805060906030604
Content-Type: text/x-diff;
 name="pppduinterruptible.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pppduinterruptible.patch"

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 24b95db..a662a24 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -658,7 +658,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		goto enable;
 	}
 
-	if (test_bit(TTY_HUPPED, &tty->flags)) {
+	if (test_bit(TTY_HUPPING, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);

--------------030506020805060906030604--
