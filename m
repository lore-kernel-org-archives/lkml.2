Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HPD10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 23:27:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43208 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0HPD1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 23:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QCHtD86lHamp7kBzu351wnpacyNZ/MlPxaJCtgKuZL3HhzTbV76pGarAqwFbGqnzQs
         FO4wAKCynlCgWYkMP2IV2I+kXZpSspjRhP9lhwqZidgzIyaYW8e3AlSkjvGEcCWRUJ4x
         crLjyPoEM9Wysmi4q8HX/5/L6DhKpLmn2YzMY=
Message-ID: <4C68B018.2030900@gmail.com>
Date: Sun, 15 Aug 2010 21:27:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: alto.tom@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: bios kernel HD swap
References: <4c5b9d66.26f88e0a.321c.40a1@mx.google.com>
In-Reply-To: <4c5b9d66.26f88e0a.321c.40a1@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 11:28 PM, alto.tom@gmail.com wrote:
> kernel swap the drivers passed by BIOS
>
> Configuration:
> 1 sata driver
> 1 IDE driver primary
> PC dell optiplex 280
> boot loader LILO MBR
>
> The problem:
> Bios set sata as primary driver (/dav/sda), when the kernel start it maps
> /dev/hda as dev/sda and move the sata into /dev/sdb the system fails
> to boot if hda does not have OS, otherwise start the OS (linux) on hda
> if present but it fails due to version compatibility.
>
> Main OS is on the sata driver
>
> Kernel effeted 2.6.33 (Slackware 13.1) and 2.6.35 (latest downloaded from web).
>
> Kernel that work fine 2.6.24, 2.6.27, sata maps into /dev/sda , ide into /dev/hda.
>
> Supected: libsata

Depending on the configuration the distribution has used it's likely 
expected that ata_piix (which I assume is the driver in question) is 
running that drive in current kernel versions. You likely need to update 
your boot configuration to point to the correct device. (The kernel 
device ordering is not related to what boot order you selected in the BIOS.)
