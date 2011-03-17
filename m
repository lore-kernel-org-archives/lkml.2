Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab1CQGBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:01:35 -0400
Received: from web39421.mail.mud.yahoo.com ([66.94.239.13]:27836 "HELO
	web39421.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750822Ab1CQGBd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:01:33 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 02:01:33 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=V33dYnDEXlFVNLFQgwcNhR/7XLmUPmCgilohnBE8fc1GUhVecVpqVhV9/gfN7ogGDUdVu6y5pNf2732sj7zHnQG2SCCRLehyxIpMw2ep8XDKGjwEekeSfFisGG1ewF5gRRrxgHwd1PqKMgAbDPiFLXVhOvJUjyAfmT//Z7PAwR8=;
Message-ID: <11649.19421.qm@web39421.mail.mud.yahoo.com>
X-YMail-OSG: YNrRZmAVM1lX0xot0foAn.NIlejGcB3jOqTlOIWuJTAcpXw
 ZaNY90qBVSeVfQOunYT5THpPq28Nd4mx3PiOOD1V._pDqtzSu4.MDfQwJdxl
 ScMx5Vr8CNseMF2EyN9pHKIGs9DUrHh_RttIct_1m7hjqkygXDAGVqAks7YV
 BIThePd06draWcYLUzGJlbZhMlCFPbBCte_IiOoAA9s1S_QSkXRS.STSbacX
 dG7k1GABTC.YG88oONUNku05jVgqB_tH6.mO1JtAWhPA2u0Gn9CPBlj1YHzq
 vmCSbq7CQWRDK0JHKt8JUL98RIhZsiZnsVXQmwEM42XNIQLg-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Wed, 16 Mar 2011 22:54:51 -0700 (PDT)
From: Kenny Simpson <theonetruekenny@yahoo.com>
Subject: remap_file_pages doesn't like MAP_ANONYMOUS (but used to?)
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  In older kernels (2.6.15-2.6.18?) I was able to make an anonymous mapping and remap part of it back over itself to create a circular buffer:
  p = mmap(0, sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0)
  remap_file_pages(p + sz/2, sz/2, 0/*prot*/, 0/*offset*/, 0/*flags*/)

I find the same method fails with EINVAL on the remap_file_pages call in 2.6.35/38.  Making a dummy file or shared memory object works, but seems a bit more messy.

Why drop support for ANONYMOUS?  Is there another way to get the same effect?

thanks,
-Kenny



      
