Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2JCTsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:48:07 -0400
Received: from shutemov.name ([176.9.204.213]:59706 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2JCTsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:48:05 -0400
Date: Wed, 3 Oct 2012 22:48:39 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Access files from kernel
Message-ID: <20121003194819.GA2490@shutemov.name>
References: <4FE8CED5.104@redhat.com>
 <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
 <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:38:52AM -0700, Linus Torvalds wrote:
>+static bool fw_get_filesystem_firmware(struct firmware *fw, const char *name)
>+{
>+	int i;
>+	bool success = false;
>+	const char *fw_path[] = { "/lib/firmware/update", "/firmware", "/lib/firmware" };
>+	char *path = __getname();
>+
>+printk("Trying to load fw '%s' ", name);
>+	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
>+		struct file *file;
>+		snprintf(path, PATH_MAX, "%s/%s", fw_path[i], name);
>+
>+		file = filp_open(path, O_RDONLY, 0);

AFAIK, accessing files on filesystem form kernel directly was no-go for a
long time. What's the new rule here?

Is it worth to introduce an execption, if it's possible to solve the
problem in userspace.

-- 
 Kirill A. Shutemov
