Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083Ab2DLQi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:38:26 -0400
Received: from smtp1.su.se ([130.237.162.112]:57809 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757801Ab2DLQiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:38:24 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 12:38:24 EDT
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F870317.1030408@debian.org>
Date: Thu, 12 Apr 2012 18:30:15 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334052489.2178.9.camel@shrek.rexursive.com> <b84d15d8-f35b-4296-927b-86a722541072@email.android.com>
In-Reply-To: <b84d15d8-f35b-4296-927b-86a722541072@email.android.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-12 13:31, Bojan Smojver skrev:
> Bojan Smojver <bojan@rexursive.com> wrote:
> 
>> -	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1; 
>> +	read_pages = (low_free_pages() - snapshot_get_image_size()) / 2;
> 
> Actually, I am pretty sure this part of the patch is wrong. Image can
> be bigger than the size of non-high memory. So, this calculation may
> turn up entirely bogus numbers, given we are dealing with unsigned
> values. Sure, we clamp that a line later, so all is not lost, but
> still, it needs to be fixed.

Indeed. I think what you want is:

read_pages = min(low_free_pages(),
                 nr_free_pages() - snapshot_get_image_size()) / 2;

-- 
Pelle
