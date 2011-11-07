Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1KGXk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:40:26 -0500
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:44875 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750Ab1KGXkY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:40:24 -0500
X-AuditID: 12074425-b7f116d0000008fe-8e-4eb86c67e142
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20111107232750.GA4854@kroah.com>
Date: Mon, 7 Nov 2011 18:40:13 -0500
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Eric Paris <eparis@parisplace.org>,
        kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4BA97845-BA47-47F3-A923-9B24AB7306E9@mit.edu>
References: <4EB82F08.8060209@zytor.com> <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com> <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros> <4EB843FF.5080201@zytor.com> <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com> <4EB84F05.1000704@zytor.com> <CA+55aFxFNaRuTx-0vx+RhrkavrcNDiDh5jxcRyWPy8-QZHGD9A@mail.gmail.com> <20111107232132.2c6880a5@lxorguk.ukuu.org.uk> <20111107232750.GA4854@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1251.1)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsUixCmqrZues8PP4PIDdYvpjV4Wc9avYbNY
	vf4Ii0Xnw7PMFucWzGC0mLZR3GLpp99sFpd3zWGz+NDziM1i5YkGJotHfW/ZLS69/8DiwOOx
	c9Zddo+3DwM8Tsz4zeKxsvMxm0fryU2sHk//3GXzOPs1yuPzJjmPQ9vfsHmcaPnCGsAVxWWT
	kpqTWZZapG+XwJUxt2UTc8FbtopV09oYGxg3sHYxcnJICJhInN9xlxHCFpO4cG89WxcjF4eQ
	wD5GiVNX+pghnPWMEu/XdjFCOEeZJA50PgdrFxYIlehv2M0MYvMKGEusufWOBcRmFtCT2HH9
	F1gNm4CSxJ1P+8HinEDxfWfvMoHYLAIqEsu+NYINZRb4zywxfdthdohmbYllC19DDbWSuN/6
	kAli8wNmibfb3oAViQjISHQs2cMOcbi8RMvXO2wTGAVnITlkFpJDZiGZu4CReRWjbEpulW5u
	YmZOcWqybnFyYl5eapGuhV5uZoleakrpJkZQxLG7qO5gnHBI6RCjAAejEg/vTNEdfkKsiWXF
	lbmHGCU5mJREeedmAIX4kvJTKjMSizPii0pzUosPMUpwMCuJ8IqEAuV4UxIrq1KL8mFS0hws
	SuK8r3c4+AkJpCeWpGanphakFsFkZTg4lCR487KBGgWLUtNTK9Iyc0oQ0kwcnCDDeYCG96eC
	DC8uSMwtzkyHyJ9iVJQS5/0O0iwAksgozYPrhSXEV4ziQK8I81omA1XxAJMpXPcroMFMQIPb
	dbeBDC5JREhJNTAa1n5hLD0SxDSRMy7F5pDYtrvOF/ujTecxV9fYzyicubtyk8sB1R9HStom
	bGVQdWhwmrRsqeqG4z4dO0r32rdbHp0bcPtJ+amXvcqiyv896rZ6XrDeJrNfaf0Mvp9dOcen
	av2qncI2z0VoQrSNYIL9fm3Xh3HbXlmrTXT1+blARalXfGtDvJASS3FGoqEWc1FxIgCCzpLO
	YwMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 7, 2011, at 6:27 PM, Greg KH wrote:
> 
> So, what do we really need revoke() for these days?

As I mentioned at the kernel summit, I'd like revoke along with a formal notification from block devices that get ejected to the file system layer, and the file system should be able to call a VFS library function which revokes all open file descriptor on the ejected block device.  It would result in much cleaner handling at the file system level when a USB storage device gets pulled.

> But that's getting away from the original topic here, sorry…

Yup.   But if revoke has come up, I'd like to remind folks that there are good uses of it besides just tty devices that receive hangup events.   Having the modem connection disappear and the USB device disappear isn't all that different from a conceptual point of view.

-- Ted
 