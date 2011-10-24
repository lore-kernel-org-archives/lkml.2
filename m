Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1JXVvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:51:51 -0400
Received: from nm7-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.236]:24476 "HELO
	nm7-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756026Ab1JXVvu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:51:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 553791.5997.bm@omp1009.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=SfPax6xXSeFW3ryssapFgWbqK4KggwOzUL2GWbTIg0rpMIrqzb7hl9irWecaOKaeSiB5s96z0faoFmc2uieXnfZGnmZYGZC4cguCVbaa08cWvKBsJUMQCd5YO+l5H4Iwi13lDbGaALhrVhwYuZyY7HDHMSVBM08KkyXE3lSMELw=;
X-YMail-OSG: YWdmBkYVM1l8Hr8kIiXkxKD4MEB4z3dfQPgNJndsuoLTsGY
 PoF69oy4hTHsygBOArJ55Yf1a_9zEoqGFWJHToLLoKmcGOqJZa4GraDjym92
 GjdmZP006WTwzVx6UPKv19B05upJZgVH1H0TqNvIRMUmDbXY.LQqH6yhajoV
 Oh8Q2A1zxO9dafrmZ2Q_4Th1WVKiiOrrrMEamtbpe3bgv9gCQJxl6q_ov_1n
 CNAEFOb.CFdXRzNrcLbQdBi0Czj_lqyebIY6_BM8mcxqwoxHL.vy5spbWBtN
 Wenod.I6_J3bM6bXm5revAG0114S9BryB0RyQeVEjoTZA_SggtCA0iOyiskH
 umvkuG6IlVZ2CYKtWGyaQ0G0aSZDQoK7CGpWVp8PFuwoOwBELq2EpXKJQQ6m
 5ve5.BwPLeSOFhb6_KxoKRVxNUOjevmZrUe3bOzborDzSHI0IXEQG7RSRFnU
 UpTiJp.S1JHFFiB6Zl3vfnYGDEhkPYZiafEyDlFDFIy1zFzWEcr0JePKK1f0
 KMKLNr9zPEZHRVa2iJ286Np_MJuY0hFqX1.6BYbJzmhqpazmRwUU1DQ--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <4E9EB1BC.9020709@yahoo.co.uk> <alpine.DEB.2.00.1110191315320.2892@chino.kir.corp.google.com> <4E9F7A25.1060001@canonical.com> <alpine.DEB.2.00.1110192233280.4618@chino.kir.corp.google.com>
Message-ID: <1319493108.21408.YahooMailNeo@web25602.mail.ukl.yahoo.com>
Date: Mon, 24 Oct 2011 22:51:48 +0100 (BST)
From: Sam Tygier <samtygier@yahoo.co.uk>
Reply-To: Sam Tygier <samtygier@yahoo.co.uk>
Subject: Re: 3.1rc10 null pointer dereference ideapad_backlight_notify_power
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ike Panhc <ike.pan@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1110192233280.4618@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thu, 20 Oct 2011, Ike Panhc wrote:
>
>> This issue has been reported[1] and patch[2] is ready.
>> 
>> [1] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02340.html
>> 
>> [2] http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02343.html
>>    http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg02346.html
>> 
>
>It certainly looks like the patch in [2] will fix the issue, but it looks 
>like those are from a couple months ago and I'm still not seeing it in 
>linux-next.  Matthew, how is this going to Linus and will it be cc'd to 
>stable@vger.kernel.org?


the patch works for me (i applied it to kernel between r10 and 3.1 final). for some reason i don't understand i had to apply the patch by hand.


my git diff says:

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 0c59541..36953bd 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -492,6 +492,9 @@ static void ideapad_backlight_notify_power(struct ideapad_private *priv)
 {
        unsigned long power;
        struct backlight_device *blightdev = priv->blightdev;
+       
+       if (!blightdev)
+               return;
 
        if (read_ec_data(ideapad_handle, 0x18, &power))
                return;


i am not quite sure of the etiquette, should I repost the patch in its original form, or my version, or can someone else get this included.

thanks

sam

