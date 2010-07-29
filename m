Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0G2OxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:53:24 -0400
Received: from fall-pradero.atl.sa.earthlink.net ([207.69.195.104]:34233 "EHLO
	fall-pradero.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687Ab0G2OxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:53:22 -0400
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2010 10:53:22 EDT
Date: Thu, 29 Jul 2010 10:41:50 -0400 (EDT)
From: Mark Whitis <whitis@freelabs.com>
X-X-Sender: whitis@cervantes
To: linux-kernel@vger.kernel.org
Subject: Re: usbtmc makes Rigol DS1052E oscilloscope crash
Message-ID: <alpine.DEB.2.00.1007290906210.25904@cervantes>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25, 2010, 10:34 AM dfnsonfsduifb at gmx wrote:
> I'm experiencing trouble connecting to a Rigol DS1052E oscilloscope via
> the usbtmc USB class driver. When requesting small amounts of data it
> works quite nicely, but when requesting a large chunk (i.e. when
> requesting the whole memory to be transferred), the read aborts, the
> connection times out and ultimately this leads to the oscilloscope 
> crashing.

On my system, I have a similar problem but with somewhat different 
symptoms.

I only get 2018 bytes back, whether the scope sends 8192 or 
524288 bytes.    610 bytes and 1210 bytes read ok.

In the source for this module, I notice that there is a 2048 byte buffer 
and a 10ms timeout, either of which could cause trouble depending on how 
they are used.

Linux cervantes 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:58:03 UTC 
2009 x86_64 GNU/Linux

./rigolterm
Rigol Technologies,DS1052E,DS1ED122307041,00.02.04.00.01
Rigol Technologies,DS1052E,DS1ED122307041,00.02.04.00.01
rigol> *IDN?
[56]:Rigol Technologies,DS1052E,DS1ED122307041,00.02.04.00.01
rigol> :ACQUIRE:MEMDEPTH LONG
No response
[-1]:
rigol> :WAVFORM:POINTS:MODE RAW
No response
[-1]:
rigol> :RUN
No response
[-1]:
rigol> :FORCE
No response
[-1]:
rigol> :STOP
No response
[-1]:
rigol> :CHAN1:MEMD?
No response
[-1]:
rigol> :CHAN1:MEMD?
No response
[-1]:
rigol> :CHAN1:MEMD?
No response
[-1]:
rigol> :CHAN1:MEMD?
No response
[-1]:
rigol> :CHAN1:MEMD?
[6]:524288
rigol> :WAV:DATA? CHANNEL1
No response
[-1]:
rigol> :WAV:DATA? CHANNEL1
No response
[-1]:
rigol> :WAV:DATA? CHANNEL1
[2018]:
23 38 30 30 35 32 34 32 38 38 CA CA CA CA CA CA
CA CA CA CA CA CA CA CA CA CA CA CA CA CA CA CA
CA C9 CA C9 CA C9 CA CA C9 CA CA CA CA C9 C9 CA
CA C9 C9 C9 C9 C9 CA CA C9 CA CA CA C9 C9 C9 C9
C9 CA CA CA CA C9 CA CA C9 CA CA CA CA C9 CA C9
CA C9 CA CA CA CA C9 C9 C9 CA CA C9 C9 CA C9 CA
CA C9 CA CA CA CA C9 CA CA CA CA CA CA C9 CA C9
CA C9 C9 C9 C9 CA CA C9 C9 CA CA CA CA CA C9 C9
CA CA CA C9 CA C9 CA C9 CA C9 C9 CA C9 CA CA C9
C9 CA C9 CA C9 C9 C9 CA C9 CA CA C9 C9 CA CA CA
C9 C9 C9 CA CA CA CA CA CA CA C9 C9 C9 CA C9 C9
C9 C9 CA CA C9 C9 C9 CA C9 CA C9 C9 CA C9 CA CA
C9 C9 CA CA C9 C9 CA CA CA C9 CA C9 CA CA CA CA
C9 C9 CA CA CA CA CA CA C9 CA C9 CA C9 CA CA C9
C9 CA CA CA CA CA C9 CA C9 C9 CA CA C9 C9 CA CA
CA CA C9 C9 C9 CA C9 CA C9 C9 C9 CA CA C9 C9 C9
C9 C9 CA CA CA CA C9 C9 CA C9 C9 C9 C9 C9 CA C9
CA C9 C9 CA CA CA CA C9 CA CA CA CA C9 CA CA CA
C9 C9 CA C9 C9 CA C9 CA CA CA C9 C9 CA C9 CA CA
CA CA C9 CA CA C9 C9 C9 C9 C9 C9 CA CA CA C9 C9
C9 CA CA C9 CA C9 CA C9 C9 C9 C9 C9 C9 CA C9 CA
C9 C9 CA C9 C9 C9 CA CA C9 CA CA CA CA CA CA CA
C9 C9 C9 C9 C9 CA CA CA CA C9 C9 C9 CA CA CA CA
C9 C9 C9 C9 C9 CA CA CA CA CA CA C9 CA C9 C9 C9
CA CA CA CA C9 CA CA CA C9 CA C9 C9 C9 C9 C9 C9
C9 CA C9 CA C9 CA C9 C9 C9 CA CA CA CA CA CA CA
C9 C9 C9 C9 C9 C9 CA C9 C9 C9 C9 CA CA CA CA CA
C9 C9 C9 C9 CA CA CA CA CA CA CA C9 CA CA CA C9
CA CA C9 CA C9 C9 C9 CA CA C9 CA CA C9 CA C9 CA
CA CA CA C9 C9 CA C9 CA CA C9 C9 CA CA CA CA CA
CA CA CA CA C9 CA C9 CA CA CA CA CA CA CA CA CA
CA C9 CA CA CA CA CA CA C9 C9 CA C9 CA C9 C9 CA
CA C9 C9 CA C9 CA CA CA C9 C9 CA C9 C9 CA CA CA
CA CA C9 CA CA CA CA C9 C9 C9 CA CA C9 C9 CA CA
CA CA CA C9 C9 C9 C9 CA CA C9 C9 C9 C9 C9 CA C9
C9 C9 CA CA CA CA CA CA CA CA C9 CA CA CA C9 C9
CA CA C9 CA CA CA CA CA CA C9 C9 CA CA C9 CA CA
CA CA C9 CA C9 C9 CA CA C9 CA C9 CA CA CA C9 C9
CA CA C9 CA CA CA C9 C9 C9 CA C9 C9 CA C9 CA CA
C9 CA C9 CA CA C9 C9 CA C9 CA C9 CA CA CA CA C9
C9 C9 CA CA CA CA CA CA CA CA CA CA CA CA CA CA
CA CA CA CA C9 CA CA CA CA C9 CA CA CA C9 CA C9
CA C9 C9 CA C9 CA CA CA CA C9 CA C9 CA CA CA CA
CA CA CA C9 CA CA CA C9 C9 C9 C9 C9 CA CA CA C9
CA C9 CA C9 C9 CA CA CA C9 C9 CA CA C9 C9 C9 C9
CA CA CA CA CA CA CA CA CA C9 C9 CA C9 C9 C9 C9
CA CA CA C9 C9 C9 CA CA CA CA CA CA CA CA CA C9
CA C9 C9 CA CA C9 C9 CA CA CA CA CA CA CA CA C9
C9 C9 C9 C9 C9 CA C9 CA C9 C9 CA CA C9 C9 C9 CA
CA CA CA C9 C9 CA CA C9 C9 CA CA C9 C9 C9 CA CA
CA CA C9 CA C9 CA C9 C9 C9 CA CA C9 CA C9 C9 CA
CA C9 C9 C9 CA CA C9 CA C9 CA C9 C9 C9 C9 CA CA
C9 C9 C9 CA CA CA C9 CA C9 CA CA C9 C9 C9 C9 CA
C9 CA CA C9 CA C9 CA C9 C9 C9 CA CA C9 C9 C9 CA
CA CA C9 C9 CA CA CA C9 C9 CA CA CA C9 C9 C9 C9
C9 C9 C9 CA C9 C9 CA CA CA CA C9 CA C9 CA CA C9
C9 CA CA CA C9 C9 CA C9 CA CA CA CA C9 CA C9 CA
C9 CA CA C9 C9 C9 C9 C9 C9 CA CA CA C9 C9 C9 C9
C9 C9 CA C9 C9 CA C9 CA CA CA C9 C9 CA CA C9 CA
C9 CA C9 C9 C9 C9 CA C9 C9 CA C9 C9 C9 CA CA C9
C9 CA CA C9 C9 CA CA CA C9 C9 C9 CA C9 C9 CA C9
C9 CA CA C9 C9 C9 CA CA CA C9 C9 C9 CA C9 C9 C9
CA C9 C9 CA C9 C9 C9 CA C9 C9 C9 C9 C9 C9 CA CA
C9 C9 C9 C9 CA C9 C9 C9 C9 C9 C9 CA CA CA C9 CA
CA CA C9 C9 C9 C9 CA C9 CA CA C9 C9 C9 C9 C9 C9
CA CA C9 C9 CA CA C9 C9 C9 C9 CA C9 C9 CA CA C9
C9 C9 C9 CA CA C9 C9 C9 CA C9 C9 C9 C9 CA C9 C9
C9 C9 CA C9 C9 C9 C9 CA C9 C9 CA C9 C9 C9 C9 C9
CA C9 C9 C9 C9 C9 C9 CA CA CA C9 C9 CA CA CA CA
CA C9 C9 C9 C9 CA C9 C9 C9 C9 C9 CA C9 C9 C9 CA
C9 CA C9 CA CA C9 CA CA C9 C9 CA C9 C9 CA C9 C9
C9 C9 CA CA C9 C9 C9 C9 CA C9 C9 CA CA CA C9 C9
CA C9 C9 CA C9 C9 CA C9 C9 CA CA C9 C9 C9 C9 CA
CA CA C9 CA C9 C9 CA CA CA C9 CA CA C9 CA CA C9
C9 C9 C9 CA C9 C9 CA C9 C9 C9 C9 C9 CA CA CA CA
C9 CA CA CA C9 C9 C9 C9 CA C9 CA C9 C9 C9 C9 C9
CA CA C9 C9 C9 CA C9 CA CA C9 C9 CA CA C9 C9 C9
C9 C9 C9 C9 C9 C9 CA CA C9 C9 C9 C9 CA C9 C9 CA
CA C9 C9 C9 C9 C9 CA C9 CA CA C9 C9 C9 C9 C9 C9
CA C9 CA C9 C9 C9 C9 C9 C9 CA CA C9 C9 C9 C9 C9
CA CA C9 CA CA C9 C9 C9 C9 C9 CA C9 CA C9 C9 C9
C9 CA CA CA C9 C9 C9 C9 CA CA CA CA C9 CA C9 C9
C9 C9 CA C9 CA C9 C9 CA C9 C9 CA C9 CA CA C9 C9
CA CA CA CA C9 C9 CA C9 C9 C9 CA C9 C9 C9 C9 C9
CA CA C9 C9 C9 CA CA C9 C9 C9 C9 CA C9 CA C9 C9
CA CA C9 CA C9 CA CA C9 C9 C9 CA C9 C9 CA C9 C9
C9 C9 C9 C9 C9 CA C9 C9 C9 CA CA CA C9 C9 CA C9
C9 C9 CA CA C9 CA CA C9 CA C9 C9 CA C9 CA C9 CA
C9 C9 C9 C9 CA C9 C9 CA C9 CA C9 C9 C9 C9 CA C9
CA C9 CA C9 CA C9 C9 C9 C9 CA C9 C9 C9 C9 C9 C9
C9 C9 C9 C9 C9 C9 C9 C9 C9 C9 C9 C9 C9 CA C9 C9
CA C9 C9 C9 CA CA C9 CA CA C9 C9 CA C9 C9 CA CA
C9 C9 CA CA C9 C9 C9 C9 CA C9 C9 CA CA C9 CA C9
C9 C9 CA CA C9 C9 C9 C9 C9 CA C9 C9 C9 CA CA CA
C9 C9 CA CA C9 CA CA C9 C9 CA C9 CA C9 C9 CA C9
C9 C9 CA C9 CA C9 C9 C9 C9 C9 CA C9 C9 C9 C9 C9
C9 C9 C9 C9 C9 C9 C9 C9 C9 CA CA C9 C9 C9 CA C9
C9 CA C9 C9 CA C9 C9 C9 C9 C9 C9 C9 C9 C9 C9 C9
CA C9 C9 CA C9 C9 CA CA C9 C9 CA C9 C9 C9 C9 C9
CA C9 CA C9 C9 C9 C9 C9 C9 CA C9 C9 C9 C9 CA CA
C9 CA C9 C9 C9 CA C9 C9 CA CA C9 C9 C9 C9 CA C9
C9 CA C9 C9 C9 C9 CA CA C9 C9 C9 C9 CA C9 C9 CA
C9 C9 C9 C9 C9 C9 C9 CA CA C9 C9 CA C9 CA CA C9
C9 C9 C9 C9 C9 CA C9 C9 CA C9 C9 C9 CA CA C9 C9
C9 C9 CA C9 CA CA C9 CA CA C9 C9 CA C9 CA CA CA
CA CA CA C9 C9 C9 C9 C9 CA C9 C9 CA C9 C9 C9 C9
C9 C9 C9 C9 CA CA CA C9 C9 CA C9 C9 CA C9 CA C9
C9 CA C9 CA C9 CA C9 C9 C9 C9 CA C9 CA CA CA C9
C9 C9 C9 C9 C9 CA CA CA C9 C9 C9 C9 C9 CA C9 C9
C9 C9 CA CA C9 CA C9 CA C9 C9 CA C9 CA C9 C9 C9
C9 C9 C9 CA C9 CA C9 C9 CA C9 CA C9 C9 CA C9 CA
C9 CA C9 CA C9 C9 CA C9 CA CA CA C9 CA C9 CA C9
C9 C9 C9 C9 CA CA C9 C9 C9 C9 C9 C9 CA CA C9 C9
CA CA CA C9 C9 CA CA CA CA C9 CA CA C9 CA CA CA
C9 CA C9 C9 C9 C9 C9 CA C9 C9 CA CA CA C9 C9 C9
CA CA C9 CA C9 C9 C9 CA CA CA C9 CA C9 C9 CA C9
C9 C9 CA C9 C9 C9 C9 C9 CA CA C9 C9 CA C9 C9 C9
C9 C9 C9 C9 C9 C9 CA CA C9 C9 C9 CA CA C9 C9 CA
CA C9 C9 C9 C9 CA C9 CA C9 C9 CA C9 CA C9 C9 C9
C9 C9 C9 C9 CA C9 CA C9 C9 CA CA C9 C9 CA CA CA
C9 CA CA CA C9 CA CA CA C9 CA C9 C9 CA CA C9 CA
CA CA C9 C9 CA CA C9 C9 CA C9 C9 CA CA C9 C9 C9
C9 C9 C9 CA C9 CA C9 C9 CA CA C9 C9 C9 C9 CA C9
CA CA C9 C9 C9 C9 CA CA C9 C9 CA C9 CA C9 C9 CA
CA CA C9 CA CA CA C9 C9 C9 CA CA C9 CA C9 C9 C9
CA C9 C9 C9 CA C9 C9 C9 C9 C9 C9 C9 CA CA C9 C9
C9 CA
rigol>


rigol> :WAVE:DATA? CHANNEL1
No response
[-1]:
rigol> :WAVE:DATA? CHANNEL1
No response
[-1]:
rigol> *IDN?
No response
[-1]:
rigol> *IDN?
No response
[-1]:
rigol> *IDN?
[56]:Rigol Technologies,DS1052E,DS1ED122307041,00.02.04.00.01
rigol> :WAV:DATA? CHANNEL1
[2018]:
23 38 30 30 35 32 34 32 38 38 CA CA CA CA CA CA
CA CA CA CA CA CA CA CA CA CA CA CA CA CA CA CA
CA C9 CA C9 CA C9 CA CA C9 CA CA CA CA C9 C9 CA
...


Bytes 2-9 (starting at 0) in the response are the length of the following 
data in ASCII digits: 00524288. Some flakyness on intermittently responding
to commands is also evident.    This seems to happen after a big data
transfer.

Intermittent response to commands continues if the program is exited and 
restarted or the scope power cycled.   Even after removing and reloading 
the kernel module.



// rigolterm.c - Copyright 2010 by Mark Whitis
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <linux/usb/tmc.h>

char *new_fgets(char *s, int size, FILE *stream)
{
   char *rc;
   int i;
   s[0]=0;
   rc=fgets(s,size,stream);
   // remove newline
   for(i=0;i<size;i++) {
     if(s[i]==0) break;
     if(s[i]=='\n') s[i]=0;
   }
   // make sure string is terminated
   s[size-1]=0;
   return(rc);
}

int rigol_write(int handle, unsigned char *string)
{
   int rc;
   unsigned char buf[256];
   strncpy(buf,string,sizeof(buf));
   buf[sizeof(buf)-1]=0;
   strncat(buf,"\n",sizeof(buf));
   buf[sizeof(buf)-1]=0;
   //printf("rigol_write(): \"%s\"\n",buf);
   rc=write(handle, buf, strlen(buf));
   if(rc<0) perror("write error");
   return(rc);
}

int rigol_read(int handle, unsigned char *buf, size_t size)
{
   int rc;
   if(!size) return(-1);
   buf[0]=0;
   rc=read(handle, buf, size);
   if((rc>0) && (rc<size)) buf[rc]=0;
   if(rc<0) {
      if(errno==ETIMEDOUT) {
        printf("No response\n");
      } else {
        perror("read error");
      }
   }
   // printf("rc=%d\n",rc);
   return(rc);
}

const max_response_length=2097152;

const max_command_length=128;
main()
{
   int handle;
   int rc;
   int i;
   unsigned char buf[max_response_length];
   unsigned char cmd[max_command_length];
   handle=open("/dev/usbtmc0", O_RDWR);
   if(handle<0) {
      perror("error opening device");
      exit(1);
   }

   rigol_write(handle, "*IDN?");
   rigol_read(handle, buf, sizeof(buf));
   printf("%s\n", buf);
   rigol_write(handle, "*IDN?");
   rigol_read(handle, buf, sizeof(buf));
   printf("%s\n", buf);
   while(1) {
      printf("rigol> ");
      new_fgets(cmd,sizeof(cmd),stdin);
      rigol_write(handle, cmd);
      rc=rigol_read(handle, buf,sizeof(buf));
      if(rc<256) {
        // Assume text
        printf("[%d]:%s\n", rc,buf);
      } else {
        printf("[%d]:\n",rc);
        for(i=0;i<rc;i++) {
 	 printf("%02X ",buf[i]);
          if( (i%16)==15 ) printf("\n");
        }
        printf("\n");
      }
   }

}

Previous poster probivided packet captures and debugging output:
http://www.gossamer-threads.com/lists/linux/kernel/1230111?do=post_view_threaded

One note: when you send usb commands to the scope, it locks out the front 
panel.  You need to use :KEY:LOCK DISABLE to unlock it (repeatedly, as 
subsequent commands will lock it again).   This could make the scope 
appear crashed when it isn't.   The letters "Rmt" appear in the upper 
right corner of the screen when the front panel is locked out.

For now, I think I will try the libusb route.   The kernel driver has too 
many bugs and isn't portable across OSes.

The usbtmc kernel driver, when loaded, interferes with communicating with 
the device via libusb even if no programs have the device open.   It fails 
to release the device when not in use.   This is a serious problem. 
Different software talking to the same device may use a mix of kernel 
driver and libusb drivers.   Worse, you may have one piece of software 
which uses the kernel driver to talk to one device and another piece of 
software which uses libusb to talk to another device, concurrently.   In 
that case, you can not rmmod the kernel driver as that would prevent the 
first device from working.
