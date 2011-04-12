Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1DLJ5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:57:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:34618 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1DLJ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:57:42 -0400
Message-ID: <4DA42213.50400@suse.cz>
Date: Tue, 12 Apr 2011 11:57:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>	 <1302015561-21047-10-git-send-email-mmarek@suse.cz>	 <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz>	 <20110411150820.GA22004@sepie.suse.cz> <1302584470.26451.11.camel@x61.thuisdomein>
In-Reply-To: <1302584470.26451.11.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.4.2011 07:01, Paul Bolle wrote:
> On Mon, 2011-04-11 at 17:08 +0200, Michal Marek wrote:
>> Subject: [PATCH] x86: Do not set the rood_dev field in bzImage
[...]
> I'm not familiar with the rdev command. I assume it allows one to
> manipulate the two rootdev bytes in a kernel image.

Yes.


> Anyhow, shouldn't
> the above patch be complemented with something like the following?
>
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
> index ee3a4ea..fdc60a0 100644

That makes sense. Will you send it as a proper patch or should I fold it 
into my patch?

Michal

> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -130,7 +130,7 @@ static void die(const char * str, ...)
>
>   static void usage(void)
>   {
> -	die("Usage: build setup system [rootdev] [>  image]");
> +	die("Usage: build setup system [>  image]");
>   }
>
>   int main(int argc, char ** argv)
> @@ -138,39 +138,14 @@ int main(int argc, char ** argv)
>   	unsigned int i, sz, setup_sectors;
>   	int c;
>   	u32 sys_size;
> -	u8 major_root, minor_root;
>   	struct stat sb;
>   	FILE *file;
>   	int fd;
>   	void *kernel;
>   	u32 crc = 0xffffffffUL;
>
> -	if ((argc<  3) || (argc>  4))
> +	if (argc != 3)
>   		usage();
> -	if (argc>  3) {
> -		if (!strcmp(argv[3], "CURRENT")) {
> -			if (stat("/",&sb)) {
> -				perror("/");
> -				die("Couldn't stat /");
> -			}
> -			major_root = major(sb.st_dev);
> -			minor_root = minor(sb.st_dev);
> -		} else if (strcmp(argv[3], "FLOPPY")) {
> -			if (stat(argv[3],&sb)) {
> -				perror(argv[3]);
> -				die("Couldn't stat root device.");
> -			}
> -			major_root = major(sb.st_rdev);
> -			minor_root = minor(sb.st_rdev);
> -		} else {
> -			major_root = 0;
> -			minor_root = 0;
> -		}
> -	} else {
> -		major_root = DEFAULT_MAJOR_ROOT;
> -		minor_root = DEFAULT_MINOR_ROOT;
> -	}
> -	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
>
>   	/* Copy the setup code */
>   	file = fopen(argv[1], "r");
> @@ -193,8 +168,8 @@ int main(int argc, char ** argv)
>   	memset(buf+c, 0, i-c);
>
>   	/* Set the default root device */
> -	buf[508] = minor_root;
> -	buf[509] = major_root;
> +	buf[508] = DEFAULT_MINOR_ROOT;
> +	buf[509] = DEFAULT_MAJOR_ROOT;
>
>   	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
>
>
>

