Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1KYLW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 06:22:27 -0500
Received: from mx01.edigma.com ([195.22.21.235]:53564 "EHLO mx01.edigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1KYLW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 06:22:26 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 06:22:26 EST
Message-ID: <4ECF789F.3040001@edigma.com>
Date: Fri, 25 Nov 2011 11:14:39 +0000
From: Nuno Santos <nsantos@edigma.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org>
In-Reply-To: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This question has probably bean discussed for several times in this list 
but the information I found googling around is inconclusive to me.

I'm implementing a kernel input driver and I have successfully achieved 
my goal for at least 75%.

Since I understand that kernel floating point usage is discouraged I 
have converted most of my code to use integers. I knew that kernel 
floating point usage was already discouraged in Windows but could be 
done by saving floating point unit state.

However, there is a small part of my code that really needs floating 
point calculations and it's conversion to integer is not being trivial.

Since that part of the code is not done intensively and since I have 
already found information that leads me to believe that the same is 
possible, that is, saving fpu state and successfully achieve floating 
point calculation on kernel.

I found this article on the internet which deeply explains fpu usage in 
kernel:

http://www.linuxsmiths.com/blog/?p=253

As a conclusion, the article says that if we need to use floating point 
calculations in kernel, it is possible if we keep the state of the fpu 
unit with the following calls:

*/kernel_fpu_begin()
/**/kernel_fpu_end()

We also need to use the compiler flag -mhard-float

But when I compile I get:

error: implicit declaration of function ‘kernel_fpu_begin’ 
[-Werror=implicit-function-declaration]
error: implicit declaration of function ‘kernel_fpu_end’ 
[-Werror=implicit-function-declaration]

Doing a grep -r kernel_fpu_begin * on kernel source dir I can find 
several references to this functions but not them is included in the 
include dir. Which include do I need to have this functions found in 
compile time?

Am I even sailing in the right direction? Is this really possible or am 
I wasting my time?

I'm new to kernel programming and this is not a trivial issue for me. I 
hope you understand.

Thanks,

With my best regards,

Nuno Santos
/*
